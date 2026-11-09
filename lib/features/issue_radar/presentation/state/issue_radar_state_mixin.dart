import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/issue_radar/application/issue_radar_providers.dart';
import 'package:mocl_shared/radar/issue_feed.dart';

mixin class IssueRadarState() {
  /// 서버가 있는 빌드인지(진입점을 보일지).
  bool issueRadarAvailableState(WidgetRef ref) =>
      ref.watch(issueRadarAvailableProvider);

  /// 차단 키워드를 걸러 낸 이슈 목록.
  AsyncValue<IssueFeed> issueFeedState(WidgetRef ref) =>
      ref.watch(visibleIssueFeedProvider);

  bool isIssueReadState(WidgetRef ref, String id) =>
      ref.watch(readIssuesProvider.select((s) => s.contains(id)));

  /// 위쪽 이슈 중 안 본 게 있는지(홈 "지금 이슈" 탭의 점).
  bool hasUnreadTopIssuesState(WidgetRef ref) =>
      ref.watch(hasUnreadTopIssuesProvider);

  /// 이슈 목록을 1회 읽는다(앱 복귀 때 오래됐는지 볼 때).
  IssueFeed? readIssueFeed(WidgetRef ref) =>
      ref.read(visibleIssueFeedProvider).value;
}
