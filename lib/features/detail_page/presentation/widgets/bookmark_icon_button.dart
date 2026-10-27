import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/database/domain/entities/bookmark_data.dart';
import 'package:mocl_flutter/features/detail_page/presentation/state/detail_event_mixin.dart';
import 'package:mocl_flutter/features/detail_page/presentation/state/detail_state_mixin.dart';

/// 상세 화면 헤더의 스크랩(북마크) 토글 버튼.
/// 현재 게시물·사이트를 읽어 동작한다. (provider 접근은 detail mixin 경유)
class const BookmarkIconButton({super.key, required final Color color})
    extends ConsumerWidget
    with DetailState, DetailEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = listItemState(ref);
    final siteType = currentSiteTypeState(ref);
    final bool isOn = isBookmarkedState(ref, siteType, item.id);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        final data = BookmarkData.fromListItem(
          siteType,
          item,
          DateTime.now().millisecondsSinceEpoch,
        );
        toggleBookmark(ref, siteType, item.id, data);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Icon(
          isOn ? Icons.bookmark : Icons.bookmark_border,
          color: color,
          size: 20,
        ),
      ),
    );
  }
}
