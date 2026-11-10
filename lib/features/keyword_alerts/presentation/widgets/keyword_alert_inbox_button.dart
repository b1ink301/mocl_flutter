import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/config/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/core/presentation/widgets/plain_icon.dart';
import 'package:mocl_flutter/core/presentation/widgets/plain_icon_button.dart';

import '../state/keyword_alert_state_mixin.dart';

/// 받은 알림(알림함)으로 가는 앱바 버튼. 안 읽은 수를 배지로 보인다.
///
/// [onlyWhenInUse] 면 키워드 알림을 걸었거나 받은 알림이 있을 때만 보인다
/// (홈 앱바 — 알림을 안 쓰는 사람에게 버튼을 늘리지 않는다). 서버가 없는 빌드에서는 늘 숨긴다.
/// 목록 앱바의 종 버튼(그 게시판에 알림 걸기)과 헷갈리지 않게 종이 아니라 받은편지함 아이콘을 쓴다.
class const KeywordAlertInboxButton({
  super.key,
  final bool onlyWhenInUse = false,
}) extends ConsumerWidget with KeywordAlertState {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!keywordAlertsAvailableState(ref)) return const SizedBox.shrink();
    if (onlyWhenInUse && !keywordAlertInboxInUseState(ref)) {
      return const SizedBox.shrink();
    }
    final int unread = keywordAlertUnreadCountState(ref);
    return PlainIconButton(
      onPressed: () => context.push(Routes.keywordAlertInbox),
      semanticLabel: unread > 0 ? '받은 알림, 안 읽음 $unread개' : '받은 알림',
      semanticsId: 'keyword_alert_inbox',
      icon: Badge(
        isLabelVisible: unread > 0,
        label: Text(unread > 99 ? '99+' : '$unread'),
        child: const PlainIcon(Icons.inbox_outlined),
      ),
    );
  }
}
