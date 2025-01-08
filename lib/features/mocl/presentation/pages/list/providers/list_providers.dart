import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/app_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/providers/pagination_notifier_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/routes/mocl_routes.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'list_providers.g.dart';

@riverpod
String listSmallTitle(Ref ref) {
  final siteType = ref.watch(currentSiteTypeNotifierProvider);
  return siteType.title;
}

@riverpod
void handleListItemTap(
  Ref ref,
  BuildContext context,
  ListItem item,
) {
  final siteType = ref.read(currentSiteTypeNotifierProvider);
  final extra = [siteType, item];

  GoRouter.of(context).push(Routes.detail, extra: extra).then((_) {
    if (context.mounted) {
      final readId = ref.watch(readableStateNotifierProvider);
      if (readId == item.id && !item.isRead) {
        ref
            .read(paginationNotifierProvider.notifier)
            .updateItemReadStatus(item.id);
      }
    }
  });
}
