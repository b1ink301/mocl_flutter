// 실패 타입의 앱 쪽 입구. 공통 실패(서버 · 네트워크 · 파서)는 앱과 서버가 함께 쓰는
// `mocl_shared` 에 있고, 앱에만 있는 실패를 여기서 함께 내보낸다.
export 'package:mocl_shared/error/failures.dart';
export 'package:mocl_flutter/features/main_page/domain/errors/main_failures.dart';
