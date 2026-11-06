# mocl_server

Mocl 앱 서버. **원격 설정**(`GET /v1/config`)과 **키워드 알림**(공개 게시판 크롤 → FCM)을 맡는다.
앞으로 이슈 묶기 등이 여기에 붙는다.

- 순수 Dart(shelf). 파서 · 엔티티는 앱과 같은 `packages/mocl_shared` 를 쓴다.
- 서버가 죽어도 앱은 그대로 동작해야 한다. 앱은 마지막으로 받은 설정을 쓰고,
  한 번도 못 받았으면 앱에 박힌 기본값을 쓴다.

## API

| 경로 | 설명 |
|---|---|
| `GET /healthz` | `ok` |
| `GET /healthz/crawl` | 크롤러 상태 JSON. 마지막 한 바퀴가 10분 넘게 지났으면 `503` |
| `GET /v1/config` | 원격 설정 JSON. `ETag` 를 주고 `If-None-Match` 가 같으면 `304` |
| `GET /v1/issues` | 이슈 레이더 목록(`IssueFeed`). ETag / `304`, 첫 수집 전에는 `503` |
| `GET /v1/issues/{id}` | 이슈 하나 |
| `PUT /v1/alerts/{installId}` | 기기의 키워드 알림 등록을 통째로 덮어쓴다(`AlertRegistration`). 구독이 비면 삭제. `204` |
| `DELETE /v1/alerts/{installId}` | 등록 삭제. `204` |
| `GET /admin` | 관리 화면(원격 설정 편집). `ADMIN_TOKEN` 이 있을 때만. 아래 "관리 화면" |
| `/admin/api/*` | 관리 API. `Authorization: Bearer {ADMIN_TOKEN}` 필수 |

알림 API 는 IP 당 분당 30회로 제한하고(`429`), 본문은 64KB 까지 받는다.

설정 형식은 `packages/mocl_shared/lib/remote_config/remote_config.dart` 의 `RemoteConfig`.

```json
{
  "schemaVersion": 1,
  "userAgents": { "mobile": "Mozilla/5.0 (Linux; Android 16; Pixel 9) ... Chrome/151.0.0.0 Mobile Safari/537.36" },
  "sites": { "geekNews": { "userAgent": "mobile" }, "clien": { "userAgent": "pc" } },
  "ads": { "detail": "small", "list": { "first": 5, "interval": 15 } }
}
```

- `userAgents.mobile` · `userAgents.pc`: 앱에 박힌 프리셋 UA 를 바꾼다(그 프리셋을 쓰는 모든 사이트).
- `sites.{SiteType 이름}.userAgent`: 프리셋 이름(`mobile` · `pc`) 또는 UA 문자열.
- 사이트 이름은 `SiteType` 의 enum 이름(`geekNews`, `naverCafe` …).
- `ads.detail`: 글 상세 광고 크기(`AdsRemoteConfig`). 높이는 폰(폭 393dp) 기준.
  `compact`(목록 행 모양, ~71dp) · `small`(정사각 미디어 120dp + 글, ~144dp, **기본**) ·
  `medium`(카드, 미디어 폭×0.4 120~160dp, ~250dp) · `large`(카드, 미디어 16:9 120~280dp, ~310dp) · `off`(없음).
- `ads.list.first` · `ads.list.interval`: 목록 광고를 첫 `first` 개 글 뒤, 그다음 `interval` 개마다 넣는다
  (기본 5 · 15, 범위 1~100 · 5~100). 빠진 값은 앱 기본값.
- 앱은 **다음 실행부터** 새 설정을 쓴다(실행 중 UA 를 바꾸면 쿠키 · 연결이 꼬일 수 있다).

### 설정 바꾸기

**관리 화면**(`https://$MOCL_DOMAIN/admin`, 아래 절)에서 고치는 게 가장 편하다.
직접 고치려면 운영 서버의 `~/mocl/server/config/remote_config.json` 을 편집한다.
서버는 수정 시각을 보고 5초 안에 다시 읽는다(재시작 · 재빌드 불필요).

```bash
ssh <서버>
vi ~/mocl/server/config/remote_config.json
curl -s https://$MOCL_DOMAIN/v1/config      # 반영 확인
```

예: 상세 광고를 medium 으로, 목록 광고를 20개마다

```json
{
  "schemaVersion": 1,
  "userAgents": {},
  "sites": {},
  "ads": { "detail": "medium", "list": { "first": 5, "interval": 20 } }
}
```

서버는 설정을 **엄격하게** 검사한다. 모르는 사이트 · 프리셋 · 광고 크기, 잘못된 UA, 범위 밖 숫자가 있으면
새 파일을 버리고 직전 설정을 계속 내보낸다(`docker compose logs api` 에 사유가 남는다).
처음 뜰 때 파일이 깨져 있으면 서버가 뜨지 않는다.

주의:

- **새 항목을 쓰려면 서버 코드가 먼저 그 항목을 알아야 한다.** 서버는 `RemoteConfig` 로 읽어 다시
  직렬화해서 내보내므로, 모르는 최상위 항목은 응답에서 빠진다. `RemoteConfig` 에 항목을 더했으면
  설정 파일보다 서버 코드(아래 "갱신")를 먼저 배포하고 `curl` 로 응답에 들어갔는지 본다.
- **앱 쪽 반영 시점**: 앱은 실행 2초 뒤 설정을 받아 저장하고 **다음 실행부터** 쓴다. 기기에서 확인할 때는
  앱을 한 번 켠 뒤 완전히 종료했다가 다시 켠다.
- **앱 버전**: 그 항목을 읽는 코드가 들어간 앱만 따른다. 옛 앱은 모르는 항목을 무시하고 앱 기본값을 쓴다
  (예: `ads` 는 광고 크기 설정이 들어간 버전부터, 1.6.0+398 이하는 기존 큰 카드).
- 설정에서 항목을 빼면 앱 기본값으로 돌아간다(상세 광고 small, 목록 5 · 15).

### 관리 화면 (`/admin`)

브라우저(폰 포함)에서 원격 설정을 고친다. 광고 크기(그림 카드) · 목록 광고 위치(미리보기) ·
UA(프리셋 · 사이트별)를 폼으로 바꾸고, 나머지는 JSON 으로 직접 고친다. 저장 전에 서버와 같은 규칙으로
검사하고 **바뀌는 항목을 보여 준 뒤** 저장한다. 저장하면 바로 `/v1/config` 에 나간다.
그 밖에 변경 이력(되돌리기)과 서버 상태(알림 등록 기기 · 크롤)를 본다.

**켜기** (한 번)

```bash
ssh <서버>
cd ~/mocl/server
echo "ADMIN_TOKEN=$(openssl rand -hex 24)" >> .env     # 48자 무작위
grep ADMIN_TOKEN .env                                  # 이 값을 비밀번호 관리자에 보관
docker compose up -d                                   # 환경 변수만 바뀌었으면 재빌드 불필요
docker compose logs api | grep admin                   # "[admin] 관리 화면 사용(/admin)"
```

`ADMIN_TOKEN` 이 없거나 32자보다 짧으면 `/admin` 은 404 다(관리 화면이 꺼진다).
`docker-compose.yml` 은 관리 화면이 파일을 쓸 수 있게 `config/` 를 쓰기 가능으로 붙인다.

**들어가기**

- `https://$MOCL_DOMAIN/admin` 을 열고 토큰을 넣는다. "이 기기에서 기억하기" 를 켜면 다음부터 바로 들어간다.
- 폰 북마크용: `https://$MOCL_DOMAIN/admin#token=토큰값`. `#` 뒤는 브라우저가 서버로 보내지 않는다.
  페이지가 읽어 저장한 뒤 주소창에서 지운다. 이 주소를 메신저 등에 붙여 넣지 말 것.
- `Cmd/Ctrl + S` 로 저장.

**인증 처리 방식**

1. 서버는 `.env` 의 `ADMIN_TOKEN` 을 환경 변수로 받아 **SHA-256 해시만** 메모리에 들고 있다.
2. 관리 화면 HTML 은 비밀이 없어 누구나 받을 수 있다. 화면의 JS 가 브라우저 저장소(localStorage,
   "기억하기" 를 끄면 sessionStorage)의 토큰을 모든 API 요청에 `Authorization: Bearer {토큰}` 헤더로 붙인다.
3. 서버는 `/admin/api/*` 마다 받은 토큰을 해시해 **고정 시간 비교**한다(비교 시간으로 토큰을 추측할 수 없게).
   틀리면 `401`, 화면은 로그인으로 돌아간다.
4. 같은 IP 에서 1분에 5번 틀리면 그 IP 는 1분 동안 `429`(맞는 토큰이어도). 48자 무작위 토큰이라 대입은 사실상 불가능하다.
   IP 는 이 제한에만 1분 쓰고 버린다(접속 로그에는 남기지 않는다). 인증 실패는 `[admin] 인증 실패` 로 로그에 남는다.
5. 쿠키를 쓰지 않으므로 다른 사이트가 사용자 브라우저를 빌려 요청을 보낼 수 없다(CSRF 없음).
   CORS 헤더도 주지 않아 다른 출처의 JS 는 헤더를 붙여 요청할 수 없다.
6. 화면 응답은 `no-store` · `X-Frame-Options: DENY` · CSP(외부 요청 금지) · `noindex` 로 보낸다. 전송은 Caddy 의 HTTPS.

토큰이 새었거나 바꾸고 싶으면 `.env` 의 값을 바꾸고 `docker compose up -d`. 기존 브라우저는 다음 요청에서 로그인 화면으로 돌아간다.

**저장할 때 서버가 하는 일**

- 같은 규칙(`RemoteConfig.validate`)으로 다시 검사한다. 문제가 있으면 `422` 와 문제 목록(전부).
- 화면을 연 뒤 다른 곳(다른 탭 · ssh)에서 파일이 바뀌었으면 `409` — 덮어쓰지 않고 새로 불러오게 한다.
- 바꾸기 전 파일을 `DATA_DIR/config-history/{시각}.json` 에 남긴다(최근 50개, 데이터 볼륨이라 매일 백업에 포함).
- 파일을 제자리에 쓰고(호스트 사용자 소유 유지 — ssh 로 계속 고칠 수 있다) 바로 다시 읽는다.
  `[admin] 설정 저장 etag=… 이전본=…` 로그가 남는다.

## 키워드 알림

- 구독된 게시판을 3분마다(실패하면 최대 60분까지 늘려) 1쪽만 받는다. 같은 게시판은 구독자가 몇 명이든 한 번.
- 첫 크롤은 기록만 하고, 이후 새 글 제목이 키워드에 맞으면 FCM 으로 보낸다. 무효 토큰이면 등록을 지운다.
- 저장: sembast 파일 DB(`DATA_DIR/alerts.db`, 볼륨 `mocl_data`).
- 발송 키: Firebase 콘솔 → 프로젝트 설정 → 서비스 계정 → "새 비공개 키 생성" 으로 받은 JSON 을
  서버의 `~/mocl/server/secrets/firebase-service-account.json` 에 두고 `docker compose up -d` (재생성).
  없으면 **dry-run**: 보낼 내용만 `[push:dry-run]` 로그로 남긴다.
- 지원 사이트는 서버 IP 에서 받을 수 있는 곳만이다. 사이트가 막혔는지 확인:
  ```bash
  docker run --rm -v ~/mocl:/src -w /src/server dart:3.13.7 sh -c "dart pub get >/dev/null && dart run bin/probe.dart"
  ```

## 사이트 카나리

사이트가 HTML 을 바꿔 파서가 깨졌는지 **실제 사이트**로 확인한다. 픽스처 테스트(`mocl_shared/test`)는
저장해 둔 옛 HTML 로 돌아서 사이트가 바뀌어도 통과하므로 이걸로 잡는다.

- `lib/src/canary/canary.dart` 의 `canaryTargets` 게시판마다 목록 1쪽을 받고, 가운데 글(실패하면 다음 글)의
  상세를 받아 앱과 같은 파서로 읽는다. 제목 · 본문이 비면 고장이다.
- 판정: **고장**(파싱 실패 · 빈 목록/본문 · 404/410) / **막힘**(403 · 429 · 503 · 연결 실패 — 실행한 곳의 IP 를
  사이트가 막은 것이라 파서 문제인지 모름) / 정상. 고장이 하나라도 있으면 종료 코드 1.
- 상세는 `urlByDetail` 주소 하나만 받는다. 댓글을 따로 받는 사이트(다모앙 · 인벤 · 엠팍 · 더쿠)는 본문만 본다.
  아카라이브는 앱이 웹뷰로 받으므로 목록만 본다. 로그인이 필요한 네이버카페 · 레딧은 넣지 않았다.
- GitHub Actions `Site canary`(`.github/workflows/canary.yml`)가 매일 09:00 KST 에 돌고, 결과 표를 실행
  요약에 남긴다. 실패하면 GitHub 가 메일을 보낸다. Actions 탭에서 사이트를 골라 직접 돌릴 수도 있다.

```bash
cd server
fvm dart run bin/canary.dart                 # 전체
fvm dart run bin/canary.dart clien nate      # 일부(SiteType 이름)
```

`bin/probe.dart` 와 다른 점: probe 는 **서버 IP 에서 목록이 받아지는지**(크롤 허용 목록 정하기),
카나리는 **파서가 지금 사이트를 읽는지**(목록 + 상세)를 본다.

## 이슈 레이더

- `lib/src/radar/radar_boards.dart` 의 게시판을 5분마다 받아(`RadarCollector`) 글마다 처음 본 시각과
  반응 기록을 48시간 쌓는다(`DATA_DIR/radar.db`). 키워드 알림과 같은 게시판은 `BoardCache` 로 한 번만 받는다.
- 수집 직후 묶기(`Clusterer`) → 점수(`RadarRanker`) → JSON 캐시(`RadarFeed`). 요청은 캐시만 내보낸다.
- 묶기 결과를 실제 데이터로 보기(임계값 튜닝):
  ```bash
  docker run --rm -v mocl_mocl_data:/data:ro -v ~/mocl:/src -v mocl_pubcache:/root/.pub-cache -w /src/server \
    dart:3.13.7 sh -c "dart pub get >/dev/null && dart run bin/radar_eval.dart /data/radar.db 0.4 0.45 0.5"
  ```
- `/healthz/crawl` 은 레이더가 15분 넘게 멈춰도 503 이다(감시 스크립트가 함께 본다).

## 로컬 실행

```bash
cd server
fvm dart pub get
fvm dart test
fvm dart run bin/server.dart          # PORT=8080, CONFIG_PATH=config/remote_config.json
curl -i localhost:8080/v1/config
```

앱을 로컬 서버에 붙이려면(에뮬레이터는 호스트를 `10.0.2.2` 로 본다):

```bash
fvm flutter run --flavor dev --dart-define=MOCL_API_BASE_URL=http://10.0.2.2:8080
```

> http(평문)는 Android 기본 정책상 막힐 수 있다. 실제 배포는 https 도메인을 쓴다.

## 오라클 클라우드(A1 · arm64) 배포

1. **도메인**: A 레코드를 인스턴스 공인 IP 로. (Caddy 가 인증서를 자동 발급한다)
2. **포트 열기 — 두 군데 다**
   - VCN 보안 목록(또는 NSG)에 TCP 80 · 443 (+ UDP 443) 인그레스 추가
   - 인스턴스 안 방화벽. 오라클 Ubuntu 이미지는 iptables 가 기본으로 막는다:
     ```bash
     sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 80 -j ACCEPT
     sudo iptables -I INPUT 6 -m state --state NEW -p tcp --dport 443 -j ACCEPT
     sudo iptables -I INPUT 6 -m state --state NEW -p udp --dport 443 -j ACCEPT
     sudo netfilter-persistent save
     ```
3. **Docker 설치** 후 저장소를 받아 실행:
   ```bash
   git clone https://github.com/b1ink301/mocl_flutter.git && cd mocl_flutter/server
   cp .env.example .env && vi .env          # MOCL_DOMAIN=...
   docker compose up -d --build
   curl https://$MOCL_DOMAIN/healthz
   ```
4. **갱신**: `git pull && docker compose up -d --build`
   (빌드 단계에서 `dart test` 를 돌리므로 테스트가 깨지면 이미지가 만들어지지 않는다)

   운영 서버의 `~/mocl` 을 git 저장소가 아니라 복사본으로 둘 때는 로컬 저장소 루트에서 올린다
   (비밀 키 · `.env` 는 건드리지 않는다). `SERVER` 는 ssh 접속 이름(`~/.ssh/config` 의 Host):
   ```bash
   SERVER=<ssh 호스트>
   rsync -a --exclude .dart_tool --exclude build packages/mocl_shared $SERVER:mocl/packages/
   rsync -a --exclude .dart_tool --exclude secrets --exclude .env server/ $SERVER:mocl/server/
   ssh $SERVER 'cd ~/mocl/server && docker compose up -d --build'
   curl -s https://$MOCL_DOMAIN/v1/config
   ```
   `server/config/` 도 함께 덮어쓰므로, 서버에서 직접 고친 설정이 있으면 먼저 로컬 파일에 옮겨 둔다.

### 백업 · 감시 (`ops/`)

```bash
ops/install-cron.sh     # 한 번만(여러 번 실행해도 됨). crontab 의 "# mocl-ops" 줄만 바꾼다
```

| 스크립트 | 주기 | 하는 일 |
|---|---|---|
| `ops/backup.sh` | 매일 04:30 KST | 알림 DB(볼륨 `mocl_data`) + `config/` 를 `~/backup/mocl/mocl-날짜.tgz` 로. 14일 보관 |
| `ops/healthcheck.sh` | 5분 | `/healthz` · `/healthz/crawl`(크롤러 10분 넘게 멈추면 503) · 실패 중인 게시판 · 디스크 85% |

- 상태 알림: `server/.env` 의 `NTFY_TOPIC` 이 있으면 상태가 **바뀔 때만**(OK ↔ WARN ↔ DOWN) ntfy.sh 로 보낸다.
  폰에 ntfy 앱을 깔고 같은 토픽을 구독한다. 토픽 이름이 비밀번호 구실이니 남에게 알리지 않는다.
- 로그: `~/backup/mocl-ops.log`
- 같은 서버 안의 검사라 인스턴스가 통째로 죽으면 알 수 없다. 외부 감시(UptimeRobot 무료 등)로
  `https://도메인/healthz/crawl` 도 함께 본다.
- 백업도 같은 디스크에 있다. 인스턴스를 잃는 경우까지 대비하려면 가끔 내려받는다:
  `rsync -a $SERVER:backup/mocl/ ./mocl-backup/`
- 복원은 `ops/backup.sh` 맨 위 주석 참고.

### 무료 인스턴스 회수 주의

Always Free 계정은 7일 동안 CPU · 네트워크 · 메모리 사용률이 아주 낮은 인스턴스를
회수할 수 있다. 계정을 **종량제(PAYG)로 업그레이드**하면(무료 한도 안에서는 과금 없음)
회수 대상에서 빠진다. 정확한 조건은 오라클 문서 "Always Free Resources → Idle Compute Instances" 를 확인한다.

## 구조

```
server/
├── bin/server.dart          # 진입점(환경 변수 · SIGTERM 처리)
├── lib/src/app.dart         # 라우터 · 미들웨어(접속 로그, 500 처리)
├── lib/src/config_store.dart# 설정 파일 읽기 · 검증 · ETag · 다시 읽기
├── lib/src/admin/           # 관리 화면(HTML 한 장) · 관리 API · 토큰 인증 · 설정 이력
├── lib/src/server_log.dart  # stdout 로그, MoclLogger 연결
├── lib/src/crawl/           # 사이트 목록 받기(공유 파서 · 뽐뿌 RSS)
├── lib/src/alerts/          # 알림 저장소 · API · 크롤 루프 · FCM 발송
├── bin/probe.dart           # 서버 IP 에서 사이트별로 받아지는지 확인
├── bin/canary.dart          # 실제 사이트로 파서가 아직 읽는지 확인(lib/src/canary/)
├── config/remote_config.json
├── Dockerfile               # 빌드 컨텍스트 = 저장소 루트
├── docker-compose.yml       # api + caddy(TLS)
└── Caddyfile
```

로그 규칙: `print` 대신 `serverLog`(운영에서도 남는 로그) 또는 `MoclLogger`(개발 실행에서만)를 쓴다.
`tool/check_logging.dart` 가 `server/lib` 도 검사한다.
