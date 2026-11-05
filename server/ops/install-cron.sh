#!/usr/bin/env bash
# backup.sh(매일 04:30 KST) · healthcheck.sh(5분마다)를 crontab 에 등록한다. 여러 번 실행해도 된다.
set -euo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
LOG="$HOME/backup/mocl-ops.log"
mkdir -p "$(dirname "$LOG")"
chmod +x "$DIR/backup.sh" "$DIR/healthcheck.sh"

# 이 스크립트가 넣은 줄(# mocl-ops 표시)만 바꾼다. 다른 crontab 항목은 그대로 둔다.
{
  crontab -l 2>/dev/null | grep -v '# mocl-ops' || true
  echo "30 19 * * * $DIR/backup.sh >>$LOG 2>&1 # mocl-ops"
  echo "*/5 * * * * $DIR/healthcheck.sh >>$LOG 2>&1 # mocl-ops"
  echo "0 20 * * 0 tail -n 5000 $LOG >$LOG.tmp && mv $LOG.tmp $LOG # mocl-ops"
} | crontab -
crontab -l | grep 'mocl-ops'
