import 'package:bloc/bloc.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';

class ListItemCubit extends Cubit<ListItem> {
  ListItemCubit(super.listItem);

  void markAsRead() {
    if (!state.isRead) {
      emit(state.copyWith(isRead: true));
    }
  }

  bool isUnread() => !state.isRead;

  void toggleReadStatus() => emit(state.copyWith(isRead: !state.isRead));
}
