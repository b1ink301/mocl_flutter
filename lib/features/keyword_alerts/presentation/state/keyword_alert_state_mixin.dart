import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/database/domain/entities/favorite_data.dart';
import 'package:mocl_flutter/features/keyword_alerts/application/keyword_alert_providers.dart';
import 'package:mocl_flutter/features/remote_config/application/remote_config_providers.dart';
import 'package:mocl_shared/alerts/keyword_alerts.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';

mixin class KeywordAlertState() {
  /// 키워드 알림을 쓸 수 있는 빌드인지(서버 주소 · 모바일).
  bool keywordAlertsAvailableState(WidgetRef ref) =>
      ref.watch(keywordAlertsAvailableProvider);

  List<AlertSubscription> keywordAlertsState(WidgetRef ref) =>
      ref.watch(keywordAlertsProvider);

  /// [site] · [board] 에 걸린 알림(없으면 null). 그 게시판 버튼만 다시 그리게 고른다.
  AlertSubscription? keywordAlertForState(
    WidgetRef ref,
    SiteType site,
    String board,
  ) => ref.watch(
    keywordAlertsProvider.select(
      (subs) =>
          subs.where((s) => s.site == site && s.board == board).firstOrNull,
    ),
  );

  /// 알림 기한(원격 설정 `alerts.ttlDays`, null = 기한 없음). 실행 중에는 바뀌지 않는다.
  Duration? keywordAlertTtlState(WidgetRef ref) =>
      ref.watch(remoteConfigProvider.select((c) => c.alerts.ttl));

  /// 알림을 걸 수 있는 내 게시판.
  AsyncValue<List<FavoriteData>> keywordAlertCandidatesState(WidgetRef ref) =>
      ref.watch(keywordAlertCandidatesProvider);
}
