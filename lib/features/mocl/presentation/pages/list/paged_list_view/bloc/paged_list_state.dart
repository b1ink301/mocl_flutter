part of 'paged_list_cubit.dart';

@freezed
class PagedListState with _$PagedListState {
  const factory PagedListState.loadingPage() = LoadingPage;

  const factory PagedListState.nextPage({
    required List<ReadableListItem> list,
    required int page,
  }) = NextPage;

  const factory PagedListState.errorPage({
    required String message,
    required int page,
  }) = ErrorPage;
}
