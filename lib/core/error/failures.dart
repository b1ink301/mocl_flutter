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

class const UnknownFailure({required super.message}) extends Failure;
