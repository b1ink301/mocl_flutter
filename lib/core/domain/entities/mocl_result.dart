import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mocl_flutter/core/error/failures.dart';

part 'mocl_result.freezed.dart';

@freezed
sealed class Result<T> with _$Result {
  const factory Result.initial() = ResultInitial;

  const factory Result.loading() = ResultLoading;

  const factory Result.success(T data) = ResultSuccess;

  const factory Result.failure(Failure failure) = ResultFailure;
}
