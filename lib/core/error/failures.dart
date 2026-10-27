import 'package:equatable/equatable.dart';

// Re-export feature-specific failures for backward compatibility.
// New code should import directly from the feature's error file.
export 'package:mocl_flutter/features/html_parser/domain/errors/parser_failures.dart';
export 'package:mocl_flutter/features/main_page/domain/errors/main_failures.dart';

abstract class const Failure({required final String message})
    extends Equatable {
  @override
  List<Object> get props => [message];
}

class const ServerFailure({required super.message}) extends Failure;

class const NetworkFailure({required super.message}) extends Failure;

class const NotLoginFailure({required super.message}) extends Failure;

/// 로그인은 돼 있으나 권한(등급/멤버 레벨)이 모자라 읽을 수 없는 경우.
/// 재시도해도 결과가 같으므로 UI 는 재시도 대신 안내를 보여준다.
class const PermissionFailure({required super.message}) extends Failure;

class const UnknownFailure({required super.message}) extends Failure;
