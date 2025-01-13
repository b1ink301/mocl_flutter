part of 'list_providers.dart';

@freezed
sealed class PaginationState with _$PaginationState {
  const factory PaginationState.loading() = LoadingList;

  const factory PaginationState.loaded() = LoadedList;

  const factory PaginationState.failed(String message) = FailedList;
}
