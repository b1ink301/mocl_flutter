#!/usr/bin/env bash
# 운영 서버에 배포한다. **개발 PC(저장소)에서** 실행한다(ops/ 의 다른 스크립트는 서버에서 돈다).
#
#   SERVER=<ssh 호스트> server/ops/deploy.sh             # 테스트 → 올리기 → 빌드 · 재시작 → verify.sh
#   SERVER=<ssh 호스트> server/ops/deploy.sh --skip-tests
#   SERVER=<ssh 호스트> server/ops/deploy.sh --rollback  # 직전 배포 이미지로 되돌린다(코드는 그대로)
#
# - 서버의 `~/mocl` 은 git 저장소가 아니라 복사본이다. 공유 패키지와 server/ 를 rsync 로 맞춘다
#   (`--delete` — 로컬에서 지운 파일이 서버에 남아 빌드에 섞이지 않게).
# - 올리지 않는 것: `.env` · `secrets/`(비밀) · `config/`(관리 화면이 고치는 운영 설정) · `data/`.
#   운영 설정은 관리 화면(/admin)으로만 바꾼다. 처음 배포라 서버에 config/ 가 없을 때만 로컬 것을 올린다.
# - 빌드 중 `dart test` 가 실패하면 이미지가 만들어지지 않고 기존 컨테이너가 그대로 돈다.
# - 빌드 전에 지금 이미지를 `mocl-api:rollback` 으로 남겨 둔다.
# - 서버 주소 · ssh 이름은 저장소에 적지 않는다(공개 저장소). SERVER 환경 변수로 넘긴다.
set -euo pipefail

SERVER="${SERVER:?SERVER=<ssh 호스트> 로 실행하세요 (~/.ssh/config 의 Host)}"
REMOTE_DIR="${REMOTE_DIR:-mocl}"
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT"

skip_tests=false
rollback=false
for arg in "$@"; do
  case "$arg" in
    --skip-tests) skip_tests=true ;;
    --rollback) rollback=true ;;
    *) echo "모르는 옵션: $arg" >&2; exit 2 ;;
  esac
done

step() { printf '\n\033[1m▶ %s\033[0m\n' "$*"; }
# shellcheck disable=SC2029 # 명령은 일부러 이쪽에서 값을 넣어 보낸다.
remote() { ssh "$SERVER" "$@"; }

if $rollback; then
  step "직전 이미지로 되돌리기"
  remote "cd ~/$REMOTE_DIR/server && docker image inspect mocl-api:rollback >/dev/null \
    && docker tag mocl-api:rollback mocl-api:latest \
    && docker compose up -d --no-build api"
  echo "되돌렸습니다. 서버의 소스는 새 버전 그대로라, 다음 배포 전에 로컬 코드를 고쳐 다시 배포하세요."
  exec "$ROOT/server/ops/verify.sh"
fi

step "배포할 코드"
rev="$(git rev-parse --short HEAD)"
dirty=""
if [ -n "$(git status --porcelain -- packages/mocl_shared server)" ]; then
  dirty="+dirty"
  echo "⚠️  커밋하지 않은 서버 · 공유 패키지 변경이 함께 올라갑니다:"
  git status --short -- packages/mocl_shared server | sed 's/^/   /'
fi
echo "   $rev$dirty ($(git rev-parse --abbrev-ref HEAD))"

if ! $skip_tests; then
  step "로컬 테스트 (공유 패키지 · 서버)"
  (cd packages/mocl_shared && fvm dart test --reporter=failures-only)
  (cd server && fvm dart analyze --fatal-infos && fvm dart test --reporter=failures-only)
fi

step "서버 준비 확인"
remote "test -f ~/$REMOTE_DIR/server/.env" \
  || { echo "서버에 ~/$REMOTE_DIR/server/.env 가 없습니다(server/README.md 배포 절 참고)." >&2; exit 1; }
if ! remote "test -f ~/$REMOTE_DIR/server/config/remote_config.json"; then
  echo "   서버에 운영 설정이 없어 로컬 server/config/ 를 처음 한 번 올립니다."
  remote "mkdir -p ~/$REMOTE_DIR/server"
  rsync -a server/config "$SERVER:$REMOTE_DIR/server/"
fi

step "코드 올리기"
rsync -a --delete --exclude .dart_tool --exclude build \
  packages/mocl_shared "$SERVER:$REMOTE_DIR/packages/"
rsync -a --delete \
  --exclude .dart_tool --exclude build \
  --exclude /.env --exclude /secrets --exclude /config --exclude /data \
  --exclude /.deployed \
  server/ "$SERVER:$REMOTE_DIR/server/"
rsync -a .dockerignore "$SERVER:$REMOTE_DIR/"

step "지금 이미지 남기기 → 빌드 · 재시작 (몇 분 걸립니다)"
remote "cd ~/$REMOTE_DIR/server \
  && (docker image inspect mocl-api:latest >/dev/null 2>&1 && docker tag mocl-api:latest mocl-api:rollback || true) \
  && docker compose up -d --build \
  && printf '%s\n' '$rev$dirty $(date -u +%FT%TZ)' > .deployed"

step "확인"
"$ROOT/server/ops/verify.sh"
