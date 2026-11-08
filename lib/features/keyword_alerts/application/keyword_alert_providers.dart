import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mocl_flutter/features/database/domain/entities/favorite_data.dart';
import 'package:mocl_flutter/features/favorite/application/favorite_providers.dart';
import 'package:mocl_flutter/features/keyword_alerts/data/keyword_alert_store.dart';
import 'package:mocl_flutter/features/keyword_alerts/data/keyword_alert_sync.dart';
import 'package:mocl_flutter/features/keyword_alerts/data/push_messaging.dart';
import 'package:mocl_flutter/features/remote_config/data/remote_config_fetcher.dart'
    show moclApiBaseUrl;
import 'package:mocl_flutter/features/settings_page/application/datasource_provider.dart';
import 'package:mocl_shared/alerts/keyword_alerts.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'keyword_alert_providers.g.dart';

/// 키워드 알림을 쓸 수 있는 빌드인지. 서버 주소가 있고 모바일이어야 한다.
@Riverpod(keepAlive: true)
bool keywordAlertsAvailable(Ref ref) =>
    moclApiBaseUrl.isNotEmpty && (Platform.isAndroid || Platform.isIOS);

@Riverpod(keepAlive: true)
PushMessaging pushMessaging(Ref ref) => FirebasePushMessaging();

@Riverpod(keepAlive: true)
KeywordAlertStore keywordAlertStore(Ref ref) =>
    KeywordAlertStore(ref.watch(sharedPreferencesProvider));

@Riverpod(keepAlive: true)
KeywordAlertSync keywordAlertSync(Ref ref) {
  final Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
    ),
  );
  ref.onDispose(dio.close);
  return KeywordAlertSync(
    dio,
    moclApiBaseUrl,
    ref.watch(keywordAlertStoreProvider),
    ref.watch(pushMessagingProvider),
    Platform.isIOS ? 'ios' : 'android',
  );
}

/// 구독 목록. 바꾸면 기기에 저장하고 서버에 맞춘다.
@Riverpod(keepAlive: true)
class KeywordAlertsNotifier() extends _$KeywordAlertsNotifier {
  @override
  List<AlertSubscription> build() {
    final KeywordAlertStore store = ref.watch(keywordAlertStoreProvider);
    final List<AlertSubscription> saved = store.subscriptions();
    // 기한이 생기기 전에 건 알림은 시작 시각이 없다. 지금부터 센다(다음 동기화 때 서버에 올라간다).
    if (saved.every((s) => s.startedAt != null)) return saved;
    final int now = DateTime.now().millisecondsSinceEpoch;
    final List<AlertSubscription> migrated = [
      for (final s in saved)
        s.startedAt == null ? s.copyWith(startedAt: now) : s,
    ];
    store.saveSubscriptions(migrated);
    return migrated;
  }

  /// 같은 게시판이 있으면 바꾸고, 없으면 끝에 붙인다. 저장하면 기한을 지금부터 다시 센다.
  Future<AlertSyncResult> upsert(AlertSubscription sub) {
    final AlertSubscription renewed = sub.copyWith(
      startedAt: DateTime.now().millisecondsSinceEpoch,
    );
    final List<AlertSubscription> next = [...state];
    final int index = next.indexWhere((s) => s.boardKey == sub.boardKey);
    if (index >= 0) {
      next[index] = renewed;
    } else {
      next.add(renewed);
    }
    return _commit(next);
  }

  /// 키워드는 그대로 두고 기한만 지금부터 다시 센다.
  Future<AlertSyncResult> renew(AlertSubscription sub) => upsert(sub);

  Future<AlertSyncResult> remove(AlertSubscription sub) =>
      _commit(state.where((s) => s.boardKey != sub.boardKey).toList());

  /// 실행 취소용: 지운 구독을 원래 자리로 되돌린다.
  Future<AlertSyncResult> restore(AlertSubscription sub, int index) {
    final List<AlertSubscription> next = [...state];
    next.insert(index.clamp(0, next.length), sub);
    return _commit(next);
  }

  Future<AlertSyncResult> _commit(List<AlertSubscription> next) async {
    state = next;
    await ref.read(keywordAlertStoreProvider).saveSubscriptions(next);
    return ref.read(keywordAlertSyncProvider).sync();
  }

  Future<AlertSyncResult> sync({bool force = false}) =>
      ref.read(keywordAlertSyncProvider).sync(force: force);
}

/// 알림을 걸 수 있는 내 게시판(담은 게시판 중 서버가 받을 수 있는 사이트).
@riverpod
Future<List<FavoriteData>> keywordAlertCandidates(Ref ref) async {
  final List<FavoriteData> favorites = await ref.watch(
    favoritesProvider.future,
  );
  return favorites
      .where(
        (f) =>
            KeywordAlerts.sites.contains(f.siteType) &&
            KeywordAlerts.isAllowedBoardUrl(f.siteType, f.url),
      )
      .toList();
}
