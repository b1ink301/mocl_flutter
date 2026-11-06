#!/bin/sh
# AdMob 앱 ID 를 빌드된 Info.plist 의 GADApplicationIdentifier 에 넣는다.
# Android 의 build.gradle.kts 와 같은 방식으로, 저장소에는 넣지 않고 빌드할 때 주입한다.
#   1) 환경 변수 MOCL_ADMOB_IOS_APP_ID  2) `--dart-define(-from-file)` 의 MOCL_ADMOB_IOS_APP_ID
# 둘 다 없으면 Google 테스트 앱 ID 로 빌드한다(광고는 테스트 광고, 수익 없음).
# AdMob 앱 ID 는 플랫폼마다 따로라서 Android 의 MOCL_ADMOB_APP_ID 를 쓰지 않는다.
set -e

TEST_APP_ID="ca-app-pub-3940256099942544~1458002511"
PLIST="${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"

app_id="${MOCL_ADMOB_IOS_APP_ID:-}"
if [ -z "$app_id" ] && [ -n "${DART_DEFINES:-}" ]; then
  # DART_DEFINES 는 `KEY=VALUE` 를 각각 base64 로 인코딩해 쉼표로 이은 값이다.
  for define in $(echo "$DART_DEFINES" | tr ',' ' '); do
    decoded=$(echo "$define" | base64 --decode)
    case "$decoded" in
      MOCL_ADMOB_IOS_APP_ID=*) app_id="${decoded#MOCL_ADMOB_IOS_APP_ID=}" ;;
    esac
  done
fi
app_id="${app_id:-$TEST_APP_ID}"

# 앱 ID 는 `~`, 광고 단위 ID 는 `/`. 헷갈려 넣으면 SDK 가 시작 시 죽으므로 빌드에서 막는다.
if ! echo "$app_id" | grep -Eq '^ca-app-pub-[0-9]+~[0-9]+$'; then
  echo "error: AdMob 앱 ID(ca-app-pub-…~…) 형식이 아닙니다: $app_id" >&2
  exit 1
fi

/usr/libexec/PlistBuddy -c "Set :GADApplicationIdentifier $app_id" "$PLIST" 2>/dev/null \
  || /usr/libexec/PlistBuddy -c "Add :GADApplicationIdentifier string $app_id" "$PLIST"
if [ "$app_id" = "$TEST_APP_ID" ]; then
  echo "note: AdMob 앱 ID 가 없어 Google 테스트 앱 ID 로 빌드한다."
fi
