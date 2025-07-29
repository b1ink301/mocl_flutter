import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/injection.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/readable_flag.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/bloc/site_type_bloc.dart';
import 'package:mocl_flutter/features/mocl/presentation/routes/mocl_app_pages.dart';

class ListItemCubit extends Cubit<ListItem> {
  ListItemCubit(super.listItem);

  void _markAsRead() {
    if (!state.isRead) {
      emit(state.copyWith(isRead: true));
    }
  }

  bool isUnread() => !state.isRead;

  void toggleReadStatus() => emit(state.copyWith(isRead: !state.isRead));

  void onTap(BuildContext context) {
    final siteType = context.read<SiteTypeBloc>().state;
    final extra = [siteType, state];
    final readableFlag = getIt<ReadableFlag>()..id = -1;

    GoRouter.of(context).push(Routes.detail, extra: extra).then((_) {
      if (!context.mounted) {
        return;
      }
      if (readableFlag.id == state.id) {
        _markAsRead();
      }
    });
  }
}
