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
    r'3140a5c356ef478fc8b90f72454e2e63c068e62d';

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

/// 본문 링크가 모클이 지원하는 사이트의 글이면 인앱 브라우저 대신 상세 화면으로
/// 파싱해서 연다. 끄면 예전처럼 모든 링크를 브라우저로 연다.

@ProviderFor(OpenSiteLinksInAppNotifier)
final openSiteLinksInAppProvider = OpenSiteLinksInAppNotifierProvider._();

/// 본문 링크가 모클이 지원하는 사이트의 글이면 인앱 브라우저 대신 상세 화면으로
/// 파싱해서 연다. 끄면 예전처럼 모든 링크를 브라우저로 연다.
final class OpenSiteLinksInAppNotifierProvider
    extends $NotifierProvider<OpenSiteLinksInAppNotifier, bool> {
  /// 본문 링크가 모클이 지원하는 사이트의 글이면 인앱 브라우저 대신 상세 화면으로
  /// 파싱해서 연다. 끄면 예전처럼 모든 링크를 브라우저로 연다.
  OpenSiteLinksInAppNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'openSiteLinksInAppProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$openSiteLinksInAppNotifierHash();

  @$internal
  @override
  OpenSiteLinksInAppNotifier create() => OpenSiteLinksInAppNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$openSiteLinksInAppNotifierHash() =>
    r'69dce6e5ad8f69caea6bc27150c5f74e20c62395';

/// 본문 링크가 모클이 지원하는 사이트의 글이면 인앱 브라우저 대신 상세 화면으로
/// 파싱해서 연다. 끄면 예전처럼 모든 링크를 브라우저로 연다.

abstract class _$OpenSiteLinksInAppNotifier extends $Notifier<bool> {
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

/// 본문의 유튜브 · 영상 파일 링크를 앱 안 플레이어로 재생한다. 끄면 유튜브는
/// 유튜브 앱으로, 파일은 브라우저로 연다.

@ProviderFor(PlayVideosInAppNotifier)
final playVideosInAppProvider = PlayVideosInAppNotifierProvider._();

/// 본문의 유튜브 · 영상 파일 링크를 앱 안 플레이어로 재생한다. 끄면 유튜브는
/// 유튜브 앱으로, 파일은 브라우저로 연다.
final class PlayVideosInAppNotifierProvider
    extends $NotifierProvider<PlayVideosInAppNotifier, bool> {
  /// 본문의 유튜브 · 영상 파일 링크를 앱 안 플레이어로 재생한다. 끄면 유튜브는
  /// 유튜브 앱으로, 파일은 브라우저로 연다.
  PlayVideosInAppNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playVideosInAppProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playVideosInAppNotifierHash();

  @$internal
  @override
  PlayVideosInAppNotifier create() => PlayVideosInAppNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$playVideosInAppNotifierHash() =>
    r'7cd5fc8934d29ac444b1292f5a2142ef3076cd0a';

/// 본문의 유튜브 · 영상 파일 링크를 앱 안 플레이어로 재생한다. 끄면 유튜브는
/// 유튜브 앱으로, 파일은 브라우저로 연다.

abstract class _$PlayVideosInAppNotifier extends $Notifier<bool> {
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

/// 번역을 지원하는 사이트(레딧)의 목록 제목을 번역해 보이고, 상세도 열자마자
/// 번역한다. 목록 앱바의 번역 버튼으로 켜고 끄며 앱을 다시 켜도 유지한다.

@ProviderFor(AutoTranslateNotifier)
final autoTranslateProvider = AutoTranslateNotifierProvider._();

/// 번역을 지원하는 사이트(레딧)의 목록 제목을 번역해 보이고, 상세도 열자마자
/// 번역한다. 목록 앱바의 번역 버튼으로 켜고 끄며 앱을 다시 켜도 유지한다.
final class AutoTranslateNotifierProvider
    extends $NotifierProvider<AutoTranslateNotifier, bool> {
  /// 번역을 지원하는 사이트(레딧)의 목록 제목을 번역해 보이고, 상세도 열자마자
  /// 번역한다. 목록 앱바의 번역 버튼으로 켜고 끄며 앱을 다시 켜도 유지한다.
  AutoTranslateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'autoTranslateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$autoTranslateNotifierHash();

  @$internal
  @override
  AutoTranslateNotifier create() => AutoTranslateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$autoTranslateNotifierHash() =>
    r'6d2232a0592bfbc4152c08a39b9c72fa95fb94c6';

/// 번역을 지원하는 사이트(레딧)의 목록 제목을 번역해 보이고, 상세도 열자마자
/// 번역한다. 목록 앱바의 번역 버튼으로 켜고 끄며 앱을 다시 켜도 유지한다.

abstract class _$AutoTranslateNotifier extends $Notifier<bool> {
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

/// 목록 · 상세 제목에 말머리 태그를 보인다. 끄면 태그 없이 제목만 보인다.

@ProviderFor(ShowCategoryNotifier)
final showCategoryProvider = ShowCategoryNotifierProvider._();

/// 목록 · 상세 제목에 말머리 태그를 보인다. 끄면 태그 없이 제목만 보인다.
final class ShowCategoryNotifierProvider
    extends $NotifierProvider<ShowCategoryNotifier, bool> {
  /// 목록 · 상세 제목에 말머리 태그를 보인다. 끄면 태그 없이 제목만 보인다.
  ShowCategoryNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'showCategoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$showCategoryNotifierHash();

  @$internal
  @override
  ShowCategoryNotifier create() => ShowCategoryNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$showCategoryNotifierHash() =>
    r'4bf5cd1f55a0475d4b3e478f474f79996f7f4edb';

/// 목록 · 상세 제목에 말머리 태그를 보인다. 끄면 태그 없이 제목만 보인다.

abstract class _$ShowCategoryNotifier extends $Notifier<bool> {
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

/// 글 목록 밀도. 목록 · 검색 결과가 같이 쓴다(앱 전체 하나).

@ProviderFor(ListDensityNotifier)
final listDensityProvider = ListDensityNotifierProvider._();

/// 글 목록 밀도. 목록 · 검색 결과가 같이 쓴다(앱 전체 하나).
final class ListDensityNotifierProvider
    extends $NotifierProvider<ListDensityNotifier, ListDensity> {
  /// 글 목록 밀도. 목록 · 검색 결과가 같이 쓴다(앱 전체 하나).
  ListDensityNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'listDensityProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$listDensityNotifierHash();

  @$internal
  @override
  ListDensityNotifier create() => ListDensityNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ListDensity value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ListDensity>(value),
    );
  }
}

String _$listDensityNotifierHash() =>
    r'b00a34b93a47e82bc8d8d8f85caba2c4fcf9840a';

/// 글 목록 밀도. 목록 · 검색 결과가 같이 쓴다(앱 전체 하나).

abstract class _$ListDensityNotifier extends $Notifier<ListDensity> {
  ListDensity build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ListDensity, ListDensity>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ListDensity, ListDensity>,
              ListDensity,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
