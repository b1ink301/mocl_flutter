import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/core/presentation/widgets/plain_icon.dart';
import 'package:mocl_flutter/core/presentation/widgets/plain_icon_button.dart';
import 'package:mocl_flutter/features/database/domain/entities/bookmark_data.dart';
import 'package:mocl_flutter/features/detail_page/presentation/state/detail_event_mixin.dart';
import 'package:mocl_flutter/features/detail_page/presentation/state/detail_state_mixin.dart';

/// 상세 앱바의 스크랩(북마크) 토글 버튼.
///
/// 본문 중간에서도 누를 수 있게 작성자 헤더가 아니라 앱바 액션에 둔다
/// (floating 앱바라 살짝 역스크롤하면 바로 나온다). 목록 항목 기준으로
/// 동작하므로 본문 로딩 전에도 쓸 수 있다. (provider 접근은 detail mixin 경유)
class const BookmarkIconButton({super.key})
    extends ConsumerWidget
    with DetailState, DetailEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = listItemState(ref);
    final siteType = currentSiteTypeState(ref);
    final bool isOn = isBookmarkedState(ref, siteType, item.id);

    return PlainIconButton(
      onPressed: () {
        final data = BookmarkData.fromListItem(
          siteType,
          item,
          DateTime.now().millisecondsSinceEpoch,
        );
        toggleBookmark(ref, siteType, item.id, data);
      },
      icon: PlainIcon(isOn ? Icons.bookmark : Icons.bookmark_border),
    );
  }
}
