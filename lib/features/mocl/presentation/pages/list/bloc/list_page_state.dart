part of 'list_page_cubit.dart';

@freezed
abstract class ListPageState with _$ListPageState {
  const factory ListPageState({
    @Default(false) bool isLoading,
    @Default(false) bool hasReachedMax,
    @Default(0) int count,
    String? error,
  }) = _ListPageState;
}