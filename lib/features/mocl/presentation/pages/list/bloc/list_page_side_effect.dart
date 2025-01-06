
part of 'list_page_cubit.dart';

@freezed
sealed class ListPageSideEffect with _$ListPageSideEffect {
  const factory ListPageSideEffect.test() = ListTest;
  // const factory ListPageSideEffect.loaded() = LoadedList;
  // const factory ListPageSideEffect.failed(String message) = FailedList;
}
