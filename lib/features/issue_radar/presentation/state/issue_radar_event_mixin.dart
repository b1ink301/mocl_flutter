import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/issue_radar/application/issue_radar_providers.dart';

mixin class IssueRadarEvent() {
  Future<void> refreshIssues(WidgetRef ref) =>
      ref.read(issueFeedProvider.notifier).refresh();

  Future<void> markIssueRead(WidgetRef ref, String id) =>
      ref.read(readIssuesProvider.notifier).markRead(id);
}
