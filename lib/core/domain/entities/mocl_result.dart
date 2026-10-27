import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mocl_flutter/core/error/failures.dart';

part 'mocl_result.freezed.dart';

@freezed
sealed class Result<T> with _$Result<T> {
  const factory initial() = ResultInitial;

  const factory loading() = ResultLoading;

  const factory success(T data) = ResultSuccess;

  const factory failure(Failure failure) = ResultFailure;
}
