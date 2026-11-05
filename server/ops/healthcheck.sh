#!/usr/bin/env bash
# 서버 상태를 5분마다 본다. install-cron.sh 가 등록한다.
#
# 확인: https 응답(/healthz) · 크롤러가 도는지(/healthz/crawl) · 실패 중인 게시판 · 디스크 사용률.
# 알림: server/.env 의 NTFY_TOPIC 이 있으면 상태가 **바뀔 때만** ntfy.sh 로 보낸다
#       (폰에 ntfy 앱 설치 → 같은 토픽 구독). 토픽 이름이 곧 비밀이라 길고 무작위로 정한다.
# 같은 서버에서 도는 검사라 서버가 통째로 죽으면 알 수 없다 → 외부 감시(UptimeRobot 등)도 함께 쓴다.
set -uo pipefail
cd "$(dirname "$0")/.."
[ -f .env ] && set -a && . ./.env && set +a

DOMAIN="${MOCL_DOMAIN:?server/.env 에 MOCL_DOMAIN 이 필요합니다}"
STATE_FILE="${HEALTH_STATE_FILE:-$HOME/.mocl_health_state}"
DISK_LIMIT="${DISK_LIMIT_PERCENT:-85}"

problems=()
warnings=()

code=$(curl -s -o /dev/null -m 15 -w '%{http_code}' "https://$DOMAIN/healthz" || echo 000)
[ "$code" = 200 ] || problems+=("API 응답 없음(HTTP $code)")

crawl=$(curl -s -m 15 -w '\n%{http_code}' "https://$DOMAIN/healthz/crawl" || printf '\n000')
crawl_code=$(tail -n1 <<<"$crawl")
crawl_body=$(head -n -1 <<<"$crawl")
if [ "$crawl_code" = 503 ]; then
  problems+=("크롤러 멈춤 $crawl_body")
elif [ "$crawl_code" = 200 ]; then
  failing=$(grep -o '"failingBoards":[0-9]*' <<<"$crawl_body" | cut -d: -f2)
  [ "${failing:-0}" -gt 0 ] && warnings+=("받기 실패 중인 게시판 ${failing}개(차단 의심, docker compose logs api)")
fi

disk=$(df --output=pcent / | tail -1 | tr -dc '0-9')
[ "$disk" -ge "$DISK_LIMIT" ] && problems+=("디스크 ${disk}%")

if [ ${#problems[@]} -gt 0 ]; then
  state="DOWN: ${problems[*]}"
elif [ ${#warnings[@]} -gt 0 ]; then
  state="WARN: ${warnings[*]}"
else
  state="OK"
fi

previous=$(cat "$STATE_FILE" 2>/dev/null || echo "OK")
# 실패 게시판 수처럼 숫자만 바뀌는 건 같은 상태로 본다(알림 폭탄 방지).
kind() { cut -d: -f1 <<<"$1"; }
echo "$state" >"$STATE_FILE"
echo "$(date -u +%FT%TZ) $state"

if [ "$(kind "$state")" != "$(kind "$previous")" ] && [ -n "${NTFY_TOPIC:-}" ]; then
  if [ "$state" = OK ]; then title="Mocl 서버 정상화"; prio=default; else title="Mocl 서버 $(kind "$state")"; prio=high; fi
  curl -s -m 15 -H "Title: $title" -H "Priority: $prio" -d "$state" "https://ntfy.sh/$NTFY_TOPIC" >/dev/null || true
fi
