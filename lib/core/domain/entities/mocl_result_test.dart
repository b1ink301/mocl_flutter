import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../error/failures.dart';

enum ResultStatus() {
  initial,
  loading,
  success,
  failure
}

@immutable
class const ResultData<T>._({
  final ResultStatus status = ResultStatus.initial,
  final T? data,
  final Failure? failure,
}) extends Equatable {
  const new failure(Failure failure)
    : this._(status: ResultStatus.failure, failure: failure);

  const new initial() : this._(status: ResultStatus.initial);

  const new loading() : this._(status: ResultStatus.loading);

  const new success(T data) : this._(status: ResultStatus.success, data: data);

  @override
  List<Object?> get props => [status, data, failure];
}
