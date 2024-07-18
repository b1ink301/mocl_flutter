import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

class ServerFailure extends Failure {}
class GetMainFailure extends Failure {}
class GetListFailure extends Failure {}
class GetDetailFailure extends Failure {}
class SetMainFailure extends Failure {}
class UnknownFailure extends Failure {}

class ServerException implements Exception {}
class GetMainException implements Exception {}