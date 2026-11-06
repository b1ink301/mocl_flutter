#!/usr/bin/env bash
# 알림 DB(볼륨 mocl_data) · 원격 설정을 하루 한 번 묶어 둔다. install-cron.sh 가 등록한다.
#   ~/backup/mocl/mocl-YYYY-MM-DD.tgz, 기본 14일 보관(KEEP_DAYS)
# 복원: docker compose stop api && docker run --rm -v mocl_mocl_data:/d -v ~/backup/mocl:/b alpine \
#         sh -c "rm -rf /d/* && tar xzf /b/mocl-YYYY-MM-DD.tgz -C /d data --strip-components=1" && docker compose start api
set -euo pipefail
cd "$(dirname "$0")/.."

DEST="${BACKUP_DIR:-$HOME/backup/mocl}"
KEEP_DAYS="${KEEP_DAYS:-14}"
STAMP="$(date -u +%F)"
mkdir -p "$DEST"

# 볼륨은 컨테이너로 읽는다(호스트에서 docker 볼륨 경로를 직접 만지지 않는다).
# sembast 는 줄 단위로 덧붙이는 파일이라 도는 중에 복사해도 마지막 줄만 잘릴 수 있고,
# 그 줄은 다시 열 때 버려진다.
docker run --rm \
  -v mocl_mocl_data:/src/data:ro \
  -v "$PWD/config":/src/config:ro \
  -v "$DEST":/dest \
  alpine tar czf "/dest/mocl-$STAMP.tgz" -C /src data config

find "$DEST" -name 'mocl-*.tgz' -mtime +"$KEEP_DAYS" -delete
echo "$(date -u +%FT%TZ) backup ok: $DEST/mocl-$STAMP.tgz ($(du -h "$DEST/mocl-$STAMP.tgz" | cut -f1))"
