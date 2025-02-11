import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/last_id.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';

part 'list_state.freezed.dart';

@freezed
class ListState with _$ListState {
  const factory ListState({
    required List<ListItem> items,
    required bool isLoading,
    required int currentPage,
    required LastId lastId,
    @Default(false) bool hasReachedMax,
    String? error,
  }) = _ListState;

  factory ListState.initial(int page) => ListState(
        items: const [],
        isLoading: false,
        currentPage: page,
        hasReachedMax: false,
        lastId: LastId.empty(),
      );
}
