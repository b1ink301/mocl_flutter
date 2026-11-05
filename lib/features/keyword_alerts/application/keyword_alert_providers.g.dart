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
    r'19bcc09c2080505ec7acfb2b6b5387d6e2250323';

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
