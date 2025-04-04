part of 'list_page_cubit.dart';

@freezed
class ListPageState with _$ListPageState {
  const factory ListPageState({
    @Default(false) bool isLoading,
    @Default(0) int count,
    String? error,
  }) = _ListPageState;
}
