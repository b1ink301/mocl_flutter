import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/database/domain/entities/favorite_data.dart';
import 'package:mocl_flutter/features/keyword_alerts/application/keyword_alert_providers.dart';
import 'package:mocl_shared/alerts/keyword_alerts.dart';

mixin class KeywordAlertState() {
  /// 키워드 알림을 쓸 수 있는 빌드인지(서버 주소 · 모바일).
  bool keywordAlertsAvailableState(WidgetRef ref) =>
      ref.watch(keywordAlertsAvailableProvider);

  List<AlertSubscription> keywordAlertsState(WidgetRef ref) =>
      ref.watch(keywordAlertsProvider);

  /// 알림을 걸 수 있는 내 게시판.
  AsyncValue<List<FavoriteData>> keywordAlertCandidatesState(WidgetRef ref) =>
      ref.watch(keywordAlertCandidatesProvider);
}
