# 빌드 컨텍스트는 저장소 루트다(공유 패키지를 같이 넣어야 한다).
#   docker compose -f server/docker-compose.yml build
# 오라클 A1(arm64)에서 바로 빌드하면 arm64 이미지가 나온다.

FROM dart:3.13.7 AS build
WORKDIR /src

# 의존성 먼저(소스만 바뀌면 이 층은 캐시를 쓴다)
COPY packages/mocl_shared/pubspec.yaml packages/mocl_shared/
COPY server/pubspec.yaml server/pubspec.lock server/
RUN cd server && dart pub get

COPY packages/mocl_shared packages/mocl_shared
COPY server server
RUN cd server && dart pub get --offline && dart test && \
    mkdir -p /out && dart compile exe bin/server.dart -o /out/server

# AOT 실행 파일 + dart 이미지가 준비해 둔 최소 런타임(libc · CA 인증서)만 담는다.
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /out/server /app/server
COPY server/config /app/config
WORKDIR /app
ENV PORT=8080 CONFIG_PATH=/app/config/remote_config.json DATA_DIR=/app/data
EXPOSE 8080
CMD ["/app/server"]
