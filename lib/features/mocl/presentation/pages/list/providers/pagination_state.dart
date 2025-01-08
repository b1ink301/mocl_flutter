part of 'pagination_notifier_provider.dart';

@freezed
sealed class PaginationState with _$PaginationState {
  const factory PaginationState.initial() = _InitialList;
  const factory PaginationState.loading() = _LoadingList;

  const factory PaginationState.loaded() = _LoadedList;

  const factory PaginationState.failed(String message) = _FailedList;
}
