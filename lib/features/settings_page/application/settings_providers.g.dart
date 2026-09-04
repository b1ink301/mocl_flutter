// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SizeCacheDirNotifier)
final sizeCacheDirProvider = SizeCacheDirNotifierProvider._();

final class SizeCacheDirNotifierProvider
    extends $AsyncNotifierProvider<SizeCacheDirNotifier, String> {
  SizeCacheDirNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sizeCacheDirProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sizeCacheDirNotifierHash();

  @$internal
  @override
  SizeCacheDirNotifier create() => SizeCacheDirNotifier();
}

String _$sizeCacheDirNotifierHash() =>
    r'9fcb8b122942cd89e86c0efc876f798902095587';

abstract class _$SizeCacheDirNotifier extends $AsyncNotifier<String> {
  FutureOr<String> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<String>, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String>, String>,
              AsyncValue<String>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(ShowNickImageNotifier)
final showNickImageProvider = ShowNickImageNotifierProvider._();

final class ShowNickImageNotifierProvider
    extends $NotifierProvider<ShowNickImageNotifier, bool> {
  ShowNickImageNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'showNickImageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$showNickImageNotifierHash();

  @$internal
  @override
  ShowNickImageNotifier create() => ShowNickImageNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$showNickImageNotifierHash() =>
    r'fc6dc85a955b55f366a00d166c0886aaada8624d';

abstract class _$ShowNickImageNotifier extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// 메인 게시판 목록에 사이트 아이콘을 보일지. 끄면 제목만 남아 목록이
/// 담백해지고 한 줄 높이도 낮아진다.

@ProviderFor(ShowBoardIconNotifier)
final showBoardIconProvider = ShowBoardIconNotifierProvider._();

/// 메인 게시판 목록에 사이트 아이콘을 보일지. 끄면 제목만 남아 목록이
/// 담백해지고 한 줄 높이도 낮아진다.
final class ShowBoardIconNotifierProvider
    extends $NotifierProvider<ShowBoardIconNotifier, bool> {
  /// 메인 게시판 목록에 사이트 아이콘을 보일지. 끄면 제목만 남아 목록이
  /// 담백해지고 한 줄 높이도 낮아진다.
  ShowBoardIconNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'showBoardIconProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$showBoardIconNotifierHash();

  @$internal
  @override
  ShowBoardIconNotifier create() => ShowBoardIconNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$showBoardIconNotifierHash() =>
    r'40d9759be8848a85e19063de6b67c5306e4c5bf0';

/// 메인 게시판 목록에 사이트 아이콘을 보일지. 끄면 제목만 남아 목록이
/// 담백해지고 한 줄 높이도 낮아진다.

abstract class _$ShowBoardIconNotifier extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// 메인 화면 오른쪽의 사이트 빠른 이동 레일을 보일지. 등록한 게시판이
/// 적어 스크롤이 짧다면 꺼서 화면을 넓게 쓸 수 있다.

@ProviderFor(ShowQuickJumpNotifier)
final showQuickJumpProvider = ShowQuickJumpNotifierProvider._();

/// 메인 화면 오른쪽의 사이트 빠른 이동 레일을 보일지. 등록한 게시판이
/// 적어 스크롤이 짧다면 꺼서 화면을 넓게 쓸 수 있다.
final class ShowQuickJumpNotifierProvider
    extends $NotifierProvider<ShowQuickJumpNotifier, bool> {
  /// 메인 화면 오른쪽의 사이트 빠른 이동 레일을 보일지. 등록한 게시판이
  /// 적어 스크롤이 짧다면 꺼서 화면을 넓게 쓸 수 있다.
  ShowQuickJumpNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'showQuickJumpProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$showQuickJumpNotifierHash();

  @$internal
  @override
  ShowQuickJumpNotifier create() => ShowQuickJumpNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$showQuickJumpNotifierHash() =>
    r'b0a0860a5610450840eb95c37bee747a771e87bb';

/// 메인 화면 오른쪽의 사이트 빠른 이동 레일을 보일지. 등록한 게시판이
/// 적어 스크롤이 짧다면 꺼서 화면을 넓게 쓸 수 있다.

abstract class _$ShowQuickJumpNotifier extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
