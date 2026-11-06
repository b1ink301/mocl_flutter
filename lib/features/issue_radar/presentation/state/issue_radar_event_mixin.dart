import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/issue_radar/application/issue_radar_providers.dart';

mixin class IssueRadarEvent() {
  Future<void> refreshIssues(WidgetRef ref) =>
      ref.read(issueFeedProvider.notifier).refresh();

  Future<void> markIssueRead(WidgetRef ref, String id) =>
      ref.read(readIssuesProvider.notifier).markRead(id);

  /// 메인 화면 위 "지금 이슈" 카드를 켜고 끈다.
  Future<void> setIssueHomeCard(WidgetRef ref, bool show) =>
      ref.read(issueHomeCardProvider.notifier).set(show);

  /// 카드를 끄고, 다시 켜는 함수를 돌려준다(스낵바 "되돌리기" 용).
  /// 카드가 사라지면 그 위젯의 ref 를 더는 쓸 수 없어서 notifier 를 미리 잡아 둔다.
  Future<void> Function() closeIssueHomeCard(WidgetRef ref) {
    final IssueHomeCardNotifier notifier = ref.read(
      issueHomeCardProvider.notifier,
    );
    unawaited(notifier.set(false));
    return () => notifier.set(true);
  }
}
