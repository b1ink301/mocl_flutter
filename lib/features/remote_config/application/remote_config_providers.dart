import 'package:mocl_shared/remote_config/remote_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'remote_config_providers.g.dart';

/// 이번 실행에서 쓰는 원격 설정. `main.dart` 가 부팅 때 저장소에서 읽어 덮어쓴다.
///
/// 실행 중에는 바뀌지 않는다. 새로 받은 설정은 다음 실행부터 적용된다 —
/// 실행 중에 사이트 UA 를 바꾸면 이미 만든 클라이언트 · 쿠키와 어긋날 수 있다.
@Riverpod(keepAlive: true)
RemoteConfig remoteConfig(Ref ref) => RemoteConfig.empty;
