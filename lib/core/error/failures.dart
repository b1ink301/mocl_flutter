import 'package:equatable/equatable.dart';

// Re-export feature-specific failures for backward compatibility.
// New code should import directly from the feature's error file.
export 'package:mocl_flutter/features/html_parser/domain/errors/parser_failures.dart';
export 'package:mocl_flutter/features/main_page/domain/errors/main_failures.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

class NotLoginFailure extends Failure {
  const NotLoginFailure({required super.message});
}

class UnknownFailure extends Failure {
  const UnknownFailure({required super.message});
}
