part of 'list_providers.dart';

@freezed
sealed class PaginationState with _$PaginationState {
  const factory PaginationState.loading() = _LoadingList;

  const factory PaginationState.loaded() = _LoadedList;

  const factory PaginationState.failed(String message) = _FailedList;
}
