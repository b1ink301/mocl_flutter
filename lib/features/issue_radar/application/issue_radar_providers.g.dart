// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'issue_radar_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 서버 주소가 있는 빌드에서만 이슈 레이더를 보인다.

@ProviderFor(issueRadarAvailable)
final issueRadarAvailableProvider = IssueRadarAvailableProvider._();

/// 서버 주소가 있는 빌드에서만 이슈 레이더를 보인다.

final class IssueRadarAvailableProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// 서버 주소가 있는 빌드에서만 이슈 레이더를 보인다.
  IssueRadarAvailableProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'issueRadarAvailableProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$issueRadarAvailableHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return issueRadarAvailable(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$issueRadarAvailableHash() =>
    r'f8a09f0401a8b1687129e0138be9fe8972e4a53e';

@ProviderFor(issueRadarApi)
final issueRadarApiProvider = IssueRadarApiProvider._();

final class IssueRadarApiProvider
    extends $FunctionalProvider<IssueRadarApi, IssueRadarApi, IssueRadarApi>
    with $Provider<IssueRadarApi> {
  IssueRadarApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'issueRadarApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$issueRadarApiHash();

  @$internal
  @override
  $ProviderElement<IssueRadarApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IssueRadarApi create(Ref ref) {
    return issueRadarApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IssueRadarApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IssueRadarApi>(value),
    );
  }
}

String _$issueRadarApiHash() => r'b8ccccbee7dcb4a40f53111ff3c6e08cafaffca1';

/// 서버의 이슈 목록 그대로.

@ProviderFor(IssueFeedNotifier)
final issueFeedProvider = IssueFeedNotifierProvider._();

/// 서버의 이슈 목록 그대로.
final class IssueFeedNotifierProvider
    extends $AsyncNotifierProvider<IssueFeedNotifier, IssueFeed> {
  /// 서버의 이슈 목록 그대로.
  IssueFeedNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'issueFeedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$issueFeedNotifierHash();

  @$internal
  @override
  IssueFeedNotifier create() => IssueFeedNotifier();
}

String _$issueFeedNotifierHash() => r'ec92dc5cce9b46a17e9156ba4a7a4e76c3d52016';

/// 서버의 이슈 목록 그대로.

abstract class _$IssueFeedNotifier extends $AsyncNotifier<IssueFeed> {
  FutureOr<IssueFeed> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<IssueFeed>, IssueFeed>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<IssueFeed>, IssueFeed>,
              AsyncValue<IssueFeed>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// 차단(뮤트)한 제목 키워드가 든 글을 빼고, 글이 다 빠진 이슈는 지운 목록.
/// 글쓴이 차단은 레이더 글에 작성자 정보가 없어 쓰지 않는다.

@ProviderFor(visibleIssueFeed)
final visibleIssueFeedProvider = VisibleIssueFeedProvider._();

/// 차단(뮤트)한 제목 키워드가 든 글을 빼고, 글이 다 빠진 이슈는 지운 목록.
/// 글쓴이 차단은 레이더 글에 작성자 정보가 없어 쓰지 않는다.

final class VisibleIssueFeedProvider
    extends
        $FunctionalProvider<
          AsyncValue<IssueFeed>,
          IssueFeed,
          FutureOr<IssueFeed>
        >
    with $FutureModifier<IssueFeed>, $FutureProvider<IssueFeed> {
  /// 차단(뮤트)한 제목 키워드가 든 글을 빼고, 글이 다 빠진 이슈는 지운 목록.
  /// 글쓴이 차단은 레이더 글에 작성자 정보가 없어 쓰지 않는다.
  VisibleIssueFeedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'visibleIssueFeedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$visibleIssueFeedHash();

  @$internal
  @override
  $FutureProviderElement<IssueFeed> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<IssueFeed> create(Ref ref) {
    return visibleIssueFeed(ref);
  }
}

String _$visibleIssueFeedHash() => r'c7d4d524ad93ae9a1983e7f8075d24ae161e74ba';

@ProviderFor(issueReadStore)
final issueReadStoreProvider = IssueReadStoreProvider._();

final class IssueReadStoreProvider
    extends $FunctionalProvider<IssueReadStore, IssueReadStore, IssueReadStore>
    with $Provider<IssueReadStore> {
  IssueReadStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'issueReadStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$issueReadStoreHash();

  @$internal
  @override
  $ProviderElement<IssueReadStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IssueReadStore create(Ref ref) {
    return issueReadStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IssueReadStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IssueReadStore>(value),
    );
  }
}

String _$issueReadStoreHash() => r'314e72d312626b568973fab9264f667795b4d8c6';

/// 본 이슈 id.

@ProviderFor(ReadIssuesNotifier)
final readIssuesProvider = ReadIssuesNotifierProvider._();

/// 본 이슈 id.
final class ReadIssuesNotifierProvider
    extends $NotifierProvider<ReadIssuesNotifier, Set<String>> {
  /// 본 이슈 id.
  ReadIssuesNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'readIssuesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$readIssuesNotifierHash();

  @$internal
  @override
  ReadIssuesNotifier create() => ReadIssuesNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<String>>(value),
    );
  }
}

String _$readIssuesNotifierHash() =>
    r'33aa7f8127ba45be503e1e192e4e503b315b1336';

/// 본 이슈 id.

abstract class _$ReadIssuesNotifier extends $Notifier<Set<String>> {
  Set<String> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Set<String>, Set<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<String>, Set<String>>,
              Set<String>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
