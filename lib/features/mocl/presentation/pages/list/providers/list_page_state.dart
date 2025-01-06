part of 'list_view_model.dart';

@freezed
sealed class ListPageState with _$ListPageState {
  const factory ListPageState.loading() = LoadingList;
  const factory ListPageState.loaded() = LoadedList;
  const factory ListPageState.failed(String message) = FailedList;
}
