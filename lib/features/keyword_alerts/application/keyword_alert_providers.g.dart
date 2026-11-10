// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'keyword_alert_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 키워드 알림을 쓸 수 있는 빌드인지. 서버 주소가 있고 모바일이어야 한다.

@ProviderFor(keywordAlertsAvailable)
final keywordAlertsAvailableProvider = KeywordAlertsAvailableProvider._();

/// 키워드 알림을 쓸 수 있는 빌드인지. 서버 주소가 있고 모바일이어야 한다.

final class KeywordAlertsAvailableProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// 키워드 알림을 쓸 수 있는 빌드인지. 서버 주소가 있고 모바일이어야 한다.
  KeywordAlertsAvailableProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'keywordAlertsAvailableProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$keywordAlertsAvailableHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return keywordAlertsAvailable(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$keywordAlertsAvailableHash() =>
    r'a60c8485e6d3fa4f719c169996fecacf29dba638';

@ProviderFor(pushMessaging)
final pushMessagingProvider = PushMessagingProvider._();

final class PushMessagingProvider
    extends $FunctionalProvider<PushMessaging, PushMessaging, PushMessaging>
    with $Provider<PushMessaging> {
  PushMessagingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushMessagingProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushMessagingHash();

  @$internal
  @override
  $ProviderElement<PushMessaging> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PushMessaging create(Ref ref) {
    return pushMessaging(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PushMessaging value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PushMessaging>(value),
    );
  }
}

String _$pushMessagingHash() => r'8bfcc45c03a4672268006f1bba22d92282d07a49';

@ProviderFor(keywordAlertStore)
final keywordAlertStoreProvider = KeywordAlertStoreProvider._();

final class KeywordAlertStoreProvider
    extends
        $FunctionalProvider<
          KeywordAlertStore,
          KeywordAlertStore,
          KeywordAlertStore
        >
    with $Provider<KeywordAlertStore> {
  KeywordAlertStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'keywordAlertStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$keywordAlertStoreHash();

  @$internal
  @override
  $ProviderElement<KeywordAlertStore> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  KeywordAlertStore create(Ref ref) {
    return keywordAlertStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(KeywordAlertStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<KeywordAlertStore>(value),
    );
  }
}

String _$keywordAlertStoreHash() => r'c3f80d6be0d07c2d5e152ea8338dd4ae1fad4612';

@ProviderFor(keywordAlertSync)
final keywordAlertSyncProvider = KeywordAlertSyncProvider._();

final class KeywordAlertSyncProvider
    extends
        $FunctionalProvider<
          KeywordAlertSync,
          KeywordAlertSync,
          KeywordAlertSync
        >
    with $Provider<KeywordAlertSync> {
  KeywordAlertSyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'keywordAlertSyncProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$keywordAlertSyncHash();

  @$internal
  @override
  $ProviderElement<KeywordAlertSync> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  KeywordAlertSync create(Ref ref) {
    return keywordAlertSync(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(KeywordAlertSync value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<KeywordAlertSync>(value),
    );
  }
}

String _$keywordAlertSyncHash() => r'701fc53e68707f170bb1066df4362f6cd623826c';

/// 구독 목록. 바꾸면 기기에 저장하고 서버에 맞춘다.

@ProviderFor(KeywordAlertsNotifier)
final keywordAlertsProvider = KeywordAlertsNotifierProvider._();

/// 구독 목록. 바꾸면 기기에 저장하고 서버에 맞춘다.
final class KeywordAlertsNotifierProvider
    extends $NotifierProvider<KeywordAlertsNotifier, List<AlertSubscription>> {
  /// 구독 목록. 바꾸면 기기에 저장하고 서버에 맞춘다.
  KeywordAlertsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'keywordAlertsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$keywordAlertsNotifierHash();

  @$internal
  @override
  KeywordAlertsNotifier create() => KeywordAlertsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<AlertSubscription> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<AlertSubscription>>(value),
    );
  }
}

String _$keywordAlertsNotifierHash() =>
    r'6e95a03af75b1569af2e5c4808dbeca3f2e86498';

/// 구독 목록. 바꾸면 기기에 저장하고 서버에 맞춘다.

abstract class _$KeywordAlertsNotifier
    extends $Notifier<List<AlertSubscription>> {
  List<AlertSubscription> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<List<AlertSubscription>, List<AlertSubscription>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<AlertSubscription>, List<AlertSubscription>>,
              List<AlertSubscription>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// 알림을 걸 수 있는 내 게시판(담은 게시판 중 서버가 받을 수 있는 사이트).

@ProviderFor(keywordAlertCandidates)
final keywordAlertCandidatesProvider = KeywordAlertCandidatesProvider._();

/// 알림을 걸 수 있는 내 게시판(담은 게시판 중 서버가 받을 수 있는 사이트).

final class KeywordAlertCandidatesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<FavoriteData>>,
          List<FavoriteData>,
          FutureOr<List<FavoriteData>>
        >
    with
        $FutureModifier<List<FavoriteData>>,
        $FutureProvider<List<FavoriteData>> {
  /// 알림을 걸 수 있는 내 게시판(담은 게시판 중 서버가 받을 수 있는 사이트).
  KeywordAlertCandidatesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'keywordAlertCandidatesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$keywordAlertCandidatesHash();

  @$internal
  @override
  $FutureProviderElement<List<FavoriteData>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<FavoriteData>> create(Ref ref) {
    return keywordAlertCandidates(ref);
  }
}

String _$keywordAlertCandidatesHash() =>
    r'fa976959d490996a6946934f6d45d4a7bb1f4447';

@ProviderFor(keywordAlertInboxStore)
final keywordAlertInboxStoreProvider = KeywordAlertInboxStoreProvider._();

final class KeywordAlertInboxStoreProvider
    extends
        $FunctionalProvider<
          KeywordAlertInbox,
          KeywordAlertInbox,
          KeywordAlertInbox
        >
    with $Provider<KeywordAlertInbox> {
  KeywordAlertInboxStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'keywordAlertInboxStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$keywordAlertInboxStoreHash();

  @$internal
  @override
  $ProviderElement<KeywordAlertInbox> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  KeywordAlertInbox create(Ref ref) {
    return keywordAlertInboxStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(KeywordAlertInbox value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<KeywordAlertInbox>(value),
    );
  }
}

String _$keywordAlertInboxStoreHash() =>
    r'26309561829f72e5124454ebbb15823144887d8f';

/// 받은 알림(최신순). 기기에만 둔다. 앱이 뒤에 있을 때 받은 것은 백그라운드 isolate 가
/// 저장하므로, 앱으로 돌아올 때 [refresh] 로 다시 읽는다.

@ProviderFor(KeywordAlertInboxNotifier)
final keywordAlertInboxProvider = KeywordAlertInboxNotifierProvider._();

/// 받은 알림(최신순). 기기에만 둔다. 앱이 뒤에 있을 때 받은 것은 백그라운드 isolate 가
/// 저장하므로, 앱으로 돌아올 때 [refresh] 로 다시 읽는다.
final class KeywordAlertInboxNotifierProvider
    extends
        $AsyncNotifierProvider<KeywordAlertInboxNotifier, List<InboxAlert>> {
  /// 받은 알림(최신순). 기기에만 둔다. 앱이 뒤에 있을 때 받은 것은 백그라운드 isolate 가
  /// 저장하므로, 앱으로 돌아올 때 [refresh] 로 다시 읽는다.
  KeywordAlertInboxNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'keywordAlertInboxProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$keywordAlertInboxNotifierHash();

  @$internal
  @override
  KeywordAlertInboxNotifier create() => KeywordAlertInboxNotifier();
}

String _$keywordAlertInboxNotifierHash() =>
    r'8639bad70d8bc65a43cffa14e4e18e55add6d83a';

/// 받은 알림(최신순). 기기에만 둔다. 앱이 뒤에 있을 때 받은 것은 백그라운드 isolate 가
/// 저장하므로, 앱으로 돌아올 때 [refresh] 로 다시 읽는다.

abstract class _$KeywordAlertInboxNotifier
    extends $AsyncNotifier<List<InboxAlert>> {
  FutureOr<List<InboxAlert>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<InboxAlert>>, List<InboxAlert>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<InboxAlert>>, List<InboxAlert>>,
              AsyncValue<List<InboxAlert>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// 안 읽은 받은 알림 수.

@ProviderFor(keywordAlertUnreadCount)
final keywordAlertUnreadCountProvider = KeywordAlertUnreadCountProvider._();

/// 안 읽은 받은 알림 수.

final class KeywordAlertUnreadCountProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// 안 읽은 받은 알림 수.
  KeywordAlertUnreadCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'keywordAlertUnreadCountProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$keywordAlertUnreadCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return keywordAlertUnreadCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$keywordAlertUnreadCountHash() =>
    r'c84f470b1d65aea258f8406e7d356bf56d244ab2';
