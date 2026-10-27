import 'package:equatable/equatable.dart';

abstract class UseCase<T, P>() {
  T call(P params);
}

abstract class FutureUseCase<T, P>() {
  Future<T> call(P params);
}

class const NoParams() extends Equatable {
  @override
  List<Object> get props => [];
}
