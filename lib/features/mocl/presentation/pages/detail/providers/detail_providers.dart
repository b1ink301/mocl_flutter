import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/set_read_flag.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/app_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/use_case_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'detail_providers.g.dart';

@riverpod
ListItem listItem(ref) => throw UnimplementedError();

@Riverpod(dependencies: [listItem])
class DetailsNotifier extends _$DetailsNotifier {
  @override
  Future<Details> build() async {
    final ListItem listItem = ref.watch(listItemProvider);
    final Either<Failure, Details> result =
        await ref.read(getDetailProvider)(listItem);
    final Details data = result.getOrElse((f) => throw f);
    ref.read(_markAsReadProvider(listItem));
    return data;
  }

  void refresh() => ref.invalidateSelf();
}

@riverpod
Future<int> _markAsRead(Ref ref, ListItem listItem) async {
  if (!listItem.isRead) {
    final SiteType siteType = ref.read(currentSiteTypeNotifierProvider);
    final SetReadFlagParams params =
        SetReadFlagParams(siteType: siteType, boardId: listItem.id);
    final setReadFlag = ref.read(setReadProvider);
    final int result = await setReadFlag(params);
    ref.read(readableStateNotifierProvider.notifier).update(listItem.id);
    return result;
  }
  return -1;
}

@Riverpod(dependencies: [listItem, CurrentSiteTypeNotifier])
String detailSmallTitle(Ref ref) {
  final siteType = ref.watch(currentSiteTypeNotifierProvider);
  final listItem = ref.watch(listItemProvider);
  return '${siteType.title} > ${listItem.boardTitle}';
}

@Riverpod(dependencies: [listItem])
String detailTitle(Ref ref) {
  final listItem = ref.watch(listItemProvider);
  return listItem.title;
}

@Riverpod(dependencies: [listItem, CurrentSiteTypeNotifier])
String detailUrl(ref) {
  final siteType = ref.watch(currentSiteTypeNotifierProvider);
  final listItem = ref.watch(listItemProvider);
  return siteType == SiteType.naverCafe
      ? 'https://m.cafe.naver.com/ca-fe/web/cafes/${listItem.board}/articles/${listItem.id}'
      : listItem.url;
}
