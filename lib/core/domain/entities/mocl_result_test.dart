import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/error/failures.dart';

enum ResultStatus { initial, loading, success, failure }

@immutable
class ResultData<T> extends Equatable {
  final ResultStatus status;
  final T? data;
  final Failure? failure;

  const ResultData._({
    this.status = ResultStatus.initial,
    this.data,
    this.failure,
  });

  const ResultData.failure(Failure failure)
      : this._(
          status: ResultStatus.failure,
          failure: failure,
        );

  const ResultData.initial() : this._(status: ResultStatus.initial);

  const ResultData.loading() : this._(status: ResultStatus.loading);

  const ResultData.success(T data)
      : this._(status: ResultStatus.success, data: data);

  @override
  List<Object?> get props => [status, data, failure];
}
