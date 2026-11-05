# mocl_server

Mocl 앱 서버. 지금은 **원격 설정**(`GET /v1/config`)만 내려준다.
앞으로 공개 게시판 크롤링 · 키워드 알림 · 이슈 묶기가 여기에 붙는다.

- 순수 Dart(shelf). 파서 · 엔티티는 앱과 같은 `packages/mocl_shared` 를 쓴다.
- 서버가 죽어도 앱은 그대로 동작해야 한다. 앱은 마지막으로 받은 설정을 쓰고,
  한 번도 못 받았으면 앱에 박힌 기본값을 쓴다.

## API

| 경로 | 설명 |
|---|---|
| `GET /healthz` | `ok` |
| `GET /v1/config` | 원격 설정 JSON. `ETag` 를 주고 `If-None-Match` 가 같으면 `304` |

설정 형식은 `packages/mocl_shared/lib/remote_config/remote_config.dart` 의 `RemoteConfig`.

```json
{
  "schemaVersion": 1,
  "userAgents": { "mobile": "Mozilla/5.0 (Linux; Android 16; Pixel 9) ... Chrome/151.0.0.0 Mobile Safari/537.36" },
  "sites": { "geekNews": { "userAgent": "mobile" }, "clien": { "userAgent": "pc" } }
}
```

- `userAgents.mobile` · `userAgents.pc`: 앱에 박힌 프리셋 UA 를 바꾼다(그 프리셋을 쓰는 모든 사이트).
- `sites.{SiteType 이름}.userAgent`: 프리셋 이름(`mobile` · `pc`) 또는 UA 문자열.
- 사이트 이름은 `SiteType` 의 enum 이름(`geekNews`, `naverCafe` …).
- 앱은 **다음 실행부터** 새 설정을 쓴다(실행 중 UA 를 바꾸면 쿠키 · 연결이 꼬일 수 있다).

### 설정 바꾸기

`server/config/remote_config.json` 을 고치면 된다. 서버는 수정 시각을 보고 다시 읽는다(재시작 불필요).
서버는 설정을 **엄격하게** 검사한다. 모르는 사이트 · 프리셋, 잘못된 UA 가 있으면
새 파일을 버리고 직전 설정을 계속 내보낸다(`docker compose logs api` 에 사유가 남는다).
처음 뜰 때 파일이 깨져 있으면 서버가 뜨지 않는다.

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
├── lib/src/server_log.dart  # stdout 로그, MoclLogger 연결
├── config/remote_config.json
├── Dockerfile               # 빌드 컨텍스트 = 저장소 루트
├── docker-compose.yml       # api + caddy(TLS)
└── Caddyfile
```

로그 규칙: `print` 대신 `serverLog`(운영에서도 남는 로그) 또는 `MoclLogger`(개발 실행에서만)를 쓴다.
`tool/check_logging.dart` 가 `server/lib` 도 검사한다.
