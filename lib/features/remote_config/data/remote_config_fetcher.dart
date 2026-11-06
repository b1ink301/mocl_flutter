import 'package:dio/dio.dart';
import 'package:mocl_flutter/features/remote_config/data/remote_config_store.dart';
import 'package:mocl_shared/util/mocl_logger.dart';

/// 서버 주소. `--dart-define`(또는 `--dart-define-from-file` 의 JSON)로 넣는다.
/// 비어 있으면 원격 설정을 받지 않는다(앱 기본값만 쓴다).
const String moclApiBaseUrl = String.fromEnvironment('MOCL_API_BASE_URL');

/// 서버에서 원격 설정을 받아 [RemoteConfigStore] 에 저장한다.
///
/// 실패는 모두 조용히 넘긴다 — 서버가 없어도 앱은 저장된 설정(없으면 기본값)으로
/// 그대로 동작해야 한다.
final class RemoteConfigFetcher(
  final Dio _dio,
  final String _baseUrl,
  final RemoteConfigStore _store,
) {
  /// 받은 설정이 바뀌었으면 true.
  Future<bool> refresh() async {
    final String url = '$_baseUrl/v1/config';
    try {
      final String? etag = _store.etag;
      final Response<String> response = await _dio.get<String>(
        url,
        options: Options(
          responseType: ResponseType.plain,
          headers: {'If-None-Match': ?etag},
          validateStatus: (int? status) => status == 200 || status == 304,
        ),
      );
      if (response.statusCode == 304) {
        MoclLogger.d(() => '[remoteConfig] 304 (변경 없음)');
        return false;
      }
      final String body = response.data ?? '';
      // 저장하기 전에 읽어 본다. 형식이 맞지 않으면 기존 설정을 지키고 버린다.
      RemoteConfigStore.parse(body);
      await _store.save(body, response.headers.value('etag'));
      MoclLogger.d(() => '[remoteConfig] 새 설정 저장 (다음 실행부터 적용)');
      return true;
    } on DioException catch (e) {
      // 서버가 내려가 있거나(502 등) 오프라인. 서버 쪽에서 볼 일이라
      // 사용자 기기마다 Crashlytics 로 올리지 않는다.
      MoclLogger.w(
        () => '[remoteConfig] 받지 못함: ${e.type} ${e.response?.statusCode ?? ''}',
      );
    } on FormatException catch (e) {
      // 서버가 이 앱이 모르는 schemaVersion 으로 올라간 경우도 여기로 온다(정상).
      MoclLogger.w(() => '[remoteConfig] 형식이 맞지 않아 버린다: $e');
    } catch (e, st) {
      MoclLogger.e('원격 설정 갱신 실패', error: e, stackTrace: st);
    }
    return false;
  }
}
