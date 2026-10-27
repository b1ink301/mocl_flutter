#!/usr/bin/env bash
# release 빌드가 실제로 첫 화면까지 뜨는지 기기에서 확인한다.
#
# `flutter build apk --release` 의 성공은 런타임을 보장하지 않는다. R8 이
# JNI 로만 쓰이는 클래스를 지우거나 줄이면 빌드는 통과하고 앱만 멈춘다
# (debug 는 축소를 하지 않아 재현되지 않는다). 그래서 설치 → 실행 →
# 첫 프레임 · 부팅 실패 화면 · 크래시를 직접 본다.
#
# 사용:
#   tool/release_smoke_test.sh [기기 시리얼]
#   FLAVOR=prd tool/release_smoke_test.sh        # 기본값 dev
#   SKIP_BUILD=1 tool/release_smoke_test.sh      # 이미 빌드한 APK 로만 확인
#
# 통과하면 지금의 pubspec.lock 해시를 .dart_tool/release_smoke.stamp 에 남긴다.
# pre-commit 훅은 pubspec.lock 이 바뀐 커밋에서 이 기록을 확인한다.
set -euo pipefail
cd "$(dirname "$0")/.."

FLAVOR="${FLAVOR:-dev}"
case "$FLAVOR" in
  dev) PKG=kr.b1ink.mocl.dev ;;
  prd) PKG=kr.b1ink.mocl ;;
  *) echo "알 수 없는 FLAVOR: $FLAVOR (dev | prd)" >&2; exit 2 ;;
esac
ACTIVITY="$PKG/net.b1ink.mocl_flutter.MainActivity"
APK="build/app/outputs/flutter-apk/app-$FLAVOR-release.apk"
STAMP=".dart_tool/release_smoke.stamp"
# BootGuard 와치독(10초)이 지연 화면을 띄울 시간을 넘겨서 본다.
SETTLE_SECONDS=12

fail() { echo "❌ $*" >&2; exit 1; }

serial="${1:-${ANDROID_SERIAL:-}}"
if [ -z "$serial" ]; then
  devices=$(adb devices | awk 'NR > 1 && $2 == "device" { print $1 }')
  count=$(printf '%s' "$devices" | grep -c . || true)
  [ "$count" -ge 1 ] || fail "연결된 기기가 없습니다 (adb devices)"
  [ "$count" -eq 1 ] || fail "기기가 여러 대입니다. 시리얼을 지정하세요: $(echo $devices)"
  serial="$devices"
fi
adb_() { adb -s "$serial" "$@"; }

if [ "${SKIP_BUILD:-0}" != 1 ]; then
  defines=()
  [ -f ads.json ] && defines=(--dart-define-from-file=ads.json)
  fvm flutter build apk --release --flavor "$FLAVOR" ${defines[@]+"${defines[@]}"}
fi
[ -f "$APK" ] || fail "APK 가 없습니다: $APK"

# 기기 없이도 잡히는 원인부터: JNI 로 찾는 클래스가 R8 에 지워지거나 줄었는지.
fvm dart run tool/check_jni_keep.dart \
  "build/app/outputs/mapping/${FLAVOR}Release/mapping.txt" \
  || fail "R8 keep 규칙이 모자랍니다 (위 목록 참고)"

echo "▶ $serial 에 설치 · 실행 ($FLAVOR)"
adb_ install -r "$APK" >/dev/null
adb_ shell am force-stop "$PKG"
adb_ logcat -c

# -W 는 첫 프레임까지 기다린다. 스플래시에서 멈추면 Status: timeout.
launch=$(adb_ shell am start -W -n "$ACTIVITY" | tr -d '\r')
status=$(sed -n 's/^Status: //p' <<<"$launch")
total=$(sed -n 's/^TotalTime: //p' <<<"$launch")
[ "$status" = ok ] || fail "첫 프레임이 그려지지 않았습니다 (Status: ${status:-?}) — 스플래시에서 멈춤"

sleep "$SETTLE_SECONDS"

pid=$(adb_ shell pidof "$PKG" | tr -d '\r' || true)
[ -n "$pid" ] || fail "실행 후 ${SETTLE_SECONDS}초 안에 앱 프로세스가 죽었습니다"

# 첫 프레임은 그려졌어도 BootGuard 의 실패/지연 화면일 수 있다.
adb_ shell uiautomator dump /sdcard/mocl_smoke.xml >/dev/null 2>&1 || true
ui=$(adb_ exec-out cat /sdcard/mocl_smoke.xml 2>/dev/null || true)
adb_ shell rm -f /sdcard/mocl_smoke.xml >/dev/null 2>&1 || true
[ -n "$ui" ] || fail "UI 트리를 읽지 못했습니다 (uiautomator dump)"
if grep -q 'resource-id="boot_failure"' <<<"$ui"; then
  fail "부팅 실패 화면이 떴습니다. 화면의 오류 문구와 Crashlytics 를 확인하세요"
fi

errors=$(adb_ logcat -d --pid="$pid" \
  | grep -E 'FATAL EXCEPTION|NoSuchMethodError|ClassNotFoundException|UnsatisfiedLinkError' \
  || true)
[ -z "$errors" ] || fail "런타임 오류:"$'\n'"$errors"

mkdir -p "$(dirname "$STAMP")"
git hash-object pubspec.lock >"$STAMP"
echo "✅ release 기동 정상 (첫 프레임 ${total}ms, $FLAVOR, $serial)"
