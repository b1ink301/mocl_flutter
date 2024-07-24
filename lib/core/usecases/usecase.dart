import 'package:equatable/equatable.dart';

import '../../features/mocl/domain/entities/mocl_result.dart';

abstract class UseCaseNoFuture<Type, Params> {
  Type call(Params params);
}

abstract class UseCase<Type, Params> {
  Future<Result> call(Params params);
}

abstract class StreamUseCase<Type, Params> {
  Stream<Result> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}