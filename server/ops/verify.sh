#!/usr/bin/env bash
# 운영 서버가 제대로 떠 있는지 확인한다. **개발 PC** 에서 실행한다(deploy.sh 가 끝에 부른다).
#
#   SERVER=<ssh 호스트> server/ops/verify.sh
#   SERVER=<ssh 호스트> MOCL_DOMAIN=<도메인> server/ops/verify.sh   # 도메인을 직접 줄 때
#
# 확인: 컨테이너 상태 · 배포 버전 · /healthz · /v1/config(ETag 304) · /healthz/crawl · /v1/issues ·
#       /admin · FCM 발송 모드 · 최근 10분 오류 로그.
# 결과: 실패(FAIL)가 하나라도 있으면 종료 코드 1. 경고(WARN)는 0 으로 끝난다.
# 도메인은 저장소에 적지 않는다 — 없으면 서버의 server/.env 에서 읽는다.
set -uo pipefail

SERVER="${SERVER:?SERVER=<ssh 호스트> 로 실행하세요 (~/.ssh/config 의 Host)}"
REMOTE_DIR="${REMOTE_DIR:-mocl}"
SINCE="${SINCE:-10m}"
# shellcheck disable=SC2029 # 명령은 일부러 이쪽에서 값을 넣어 보낸다.
remote() { ssh "$SERVER" "$@"; }

fails=0
warns=0
ok() { printf '  \033[32mOK\033[0m   %s\n' "$*"; }
warn() { printf '  \033[33mWARN\033[0m %s\n' "$*"; warns=$((warns + 1)); }
fail() { printf '  \033[31mFAIL\033[0m %s\n' "$*"; fails=$((fails + 1)); }
json() { python3 -c "import json,sys; d=json.load(sys.stdin); print($1)" 2>/dev/null; }

DOMAIN="${MOCL_DOMAIN:-$(remote "grep -E '^MOCL_DOMAIN=' ~/$REMOTE_DIR/server/.env | cut -d= -f2-" 2>/dev/null)}"
[ -n "$DOMAIN" ] || { echo "도메인을 알 수 없습니다(MOCL_DOMAIN 을 주세요)." >&2; exit 1; }
BASE="https://$DOMAIN"

echo "컨테이너"
ps_out="$(remote "cd ~/$REMOTE_DIR/server && docker compose ps --format '{{.Service}} {{.State}} {{.Status}}'" 2>&1)"
for svc in api caddy; do
  line="$(grep -E "^$svc " <<<"$ps_out")"
  if grep -q ' running ' <<<"$line"; then ok "$line"; else fail "$svc: ${line:-없음}"; fi
done
deployed="$(remote "cat ~/$REMOTE_DIR/server/.deployed 2>/dev/null")"
if [ -n "$deployed" ]; then ok "배포 버전 $deployed"; else warn "배포 기록(.deployed) 없음"; fi

echo "API"
# 재시작 직후일 수 있어 60초까지 기다린다.
code=000
for _ in $(seq 1 30); do
  code="$(curl -s -o /dev/null -m 10 -w '%{http_code}' "$BASE/healthz" || echo 000)"
  [ "$code" = 200 ] && break
  sleep 2
done
if [ "$code" = 200 ]; then ok "/healthz"; else fail "/healthz HTTP $code"; fi

headers="$(mktemp)"
body="$(curl -s -m 15 -D "$headers" "$BASE/v1/config")"
etag="$(grep -i '^etag:' "$headers" | cut -d' ' -f2- | tr -d '\r')"
rm -f "$headers"
version="$(json "d['schemaVersion']" <<<"$body")"
if [ -n "$version" ]; then
  boards="$(json "', '.join(f'{s}:{b}' for s,v in d.get('alerts',{}).get('boards',{}).items() for b in v) or '기본값'" <<<"$body")"
  ok "/v1/config schemaVersion=$version · 알림 게시판: $boards"
  code="$(curl -s -o /dev/null -m 10 -w '%{http_code}' -H "If-None-Match: $etag" "$BASE/v1/config")"
  if [ "$code" = 304 ]; then ok "/v1/config ETag 304"; else warn "/v1/config ETag 재요청 HTTP $code(304 아님)"; fi
else
  fail "/v1/config 응답이 설정 JSON 이 아님"
fi

crawl="$(curl -s -m 15 -w '\n%{http_code}' "$BASE/healthz/crawl")"
crawl_code="$(tail -n1 <<<"$crawl")"
crawl_body="$(sed '$d' <<<"$crawl")"
if [ "$crawl_code" = 200 ]; then
  ok "/healthz/crawl $(json "' · '.join(f'{k}={v}' for k,v in d.items())" <<<"$crawl_body")"
  failing="$(json "d.get('failingBoards', 0)" <<<"$crawl_body")"
  [ "${failing:-0}" -gt 0 ] && warn "받기 실패 중인 게시판 ${failing}개"
  grep -q '"disallowedSubscriptions"' <<<"$crawl_body" \
    || warn "disallowedSubscriptions 가 없음 — 허용 게시판 이전 버전이 떠 있는 것 같습니다"
else
  fail "/healthz/crawl HTTP $crawl_code $crawl_body"
fi

code="$(curl -s -o /dev/null -m 15 -w '%{http_code}' "$BASE/v1/issues")"
case "$code" in
  200) ok "/v1/issues" ;;
  503) warn "/v1/issues 503(재시작 직후 첫 수집 전이면 정상, 5분 뒤 다시 확인)" ;;
  *) fail "/v1/issues HTTP $code" ;;
esac

code="$(curl -s -o /dev/null -m 10 -w '%{http_code}' "$BASE/admin")"
case "$code" in
  200) ok "/admin 열림" ;;
  404) warn "/admin 꺼짐(ADMIN_TOKEN 없음)" ;;
  *) fail "/admin HTTP $code" ;;
esac

echo "로그 (최근 $SINCE)"
logs="$(remote "cd ~/$REMOTE_DIR/server && docker compose logs --no-color --since $SINCE api" 2>&1)"
if grep -q '\[push\] FCM 발송 사용' <<<"$logs"; then
  ok "FCM 발송 사용(토큰 확인 켜짐)"
elif grep -q 'dry-run' <<<"$logs"; then
  warn "FCM dry-run — 서비스 계정 키가 없어 알림을 보내지 않고 토큰도 확인하지 않음"
else
  ok "최근 재시작 없음(FCM 모드는 시작 로그에만 남음)"
fi
invalid="$(grep -c 'invalid_token' <<<"$logs" || true)"
[ "${invalid:-0}" -gt 0 ] && warn "invalid_token 응답 ${invalid}건 — 진짜 기기라면 토큰 확인을 의심"
# "실패 0"(레이더 요약) 같은 정상 줄은 빼고, "실패(3회)" · "실패: …" 처럼 실제 실패만 본다.
errors="$(grep -E '실패[(:]|실패 [1-9]|Exception|\[error\]|Unhandled' <<<"$logs")"
if [ -n "$errors" ]; then
  warn "오류 로그 $(wc -l <<<"$errors" | tr -d ' ')줄(마지막 10줄):"
  tail -n 10 <<<"$errors" | sed 's/^/         /'
else
  ok "오류 로그 없음"
fi

echo
if [ "$fails" -gt 0 ]; then
  printf '\033[31m실패 %d · 경고 %d\033[0m  되돌리기: SERVER=%s server/ops/deploy.sh --rollback\n' "$fails" "$warns" "$SERVER"
  exit 1
fi
printf '\033[32m정상\033[0m (경고 %d)\n' "$warns"
