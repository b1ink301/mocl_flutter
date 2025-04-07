import 'package:equatable/equatable.dart';

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

class GetMainFailure extends Failure {
  const GetMainFailure({required super.message});
}

class NotLoginFailure extends Failure {
  const NotLoginFailure({required super.message});
}

class GetListFailure extends Failure {
  const GetListFailure({required super.message});
}

class GetDetailFailure extends Failure {
  const GetDetailFailure({required super.message});
}

class SetMainFailure extends Failure {
  const SetMainFailure({required super.message});
}

class UnknownFailure extends Failure {
  const UnknownFailure({required super.message});
}

class ServerException implements Exception {}

class GetMainException implements Exception {}
