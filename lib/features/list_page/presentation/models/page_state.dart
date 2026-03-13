import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mocl_flutter/core/domain/entities/last_id.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';

part 'page_state.freezed.dart';

@freezed
abstract class PageState with _$PageState {
  const factory PageState({
    required List<ListItem> items,
    required bool isLoading,
    required int currentPage,
    required LastId lastId,
    @Default(false) bool hasReachedMax,
    String? error,
  }) = _PageState;

  factory PageState.initial(int page) => PageState(
    items: const [],
    isLoading: false,
    currentPage: page,
    hasReachedMax: false,
    lastId: LastId.empty(),
  );

  factory PageState.empty() => PageState(
    items: const [],
    isLoading: false,
    currentPage: 0,
    hasReachedMax: false,
    lastId: LastId.empty(),
  );
}
