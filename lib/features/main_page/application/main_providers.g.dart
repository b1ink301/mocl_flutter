// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 앱바 제목. 홈은 '지금 보고 있는 사이트'의 담은 게시판 목록이다.

@ProviderFor(mainTitle)
final mainTitleProvider = MainTitleProvider._();

/// 앱바 제목. 홈은 '지금 보고 있는 사이트'의 담은 게시판 목록이다.

final class MainTitleProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// 앱바 제목. 홈은 '지금 보고 있는 사이트'의 담은 게시판 목록이다.
  MainTitleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mainTitleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mainTitleHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return mainTitle(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$mainTitleHash() => r'57abddfdf2e871b713c4368c9e8e3420a55ee34a';

/// 드로어 사이트 칩이 자기 차례인지만 골라 보게 한다(사이트가 바뀌어도
/// 관련 있는 칩 두 개만 다시 그려진다).

@ProviderFor(isCurrentSiteType)
final isCurrentSiteTypeProvider = IsCurrentSiteTypeFamily._();

/// 드로어 사이트 칩이 자기 차례인지만 골라 보게 한다(사이트가 바뀌어도
/// 관련 있는 칩 두 개만 다시 그려진다).

final class IsCurrentSiteTypeProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// 드로어 사이트 칩이 자기 차례인지만 골라 보게 한다(사이트가 바뀌어도
  /// 관련 있는 칩 두 개만 다시 그려진다).
  IsCurrentSiteTypeProvider._({
    required IsCurrentSiteTypeFamily super.from,
    required SiteType super.argument,
  }) : super(
         retry: null,
         name: r'isCurrentSiteTypeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$isCurrentSiteTypeHash();

  @override
  String toString() {
    return r'isCurrentSiteTypeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    final argument = this.argument as SiteType;
    return isCurrentSiteType(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is IsCurrentSiteTypeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isCurrentSiteTypeHash() => r'2d08740bc69db68baad12dc057b6cab1d5b9a04f';

/// 드로어 사이트 칩이 자기 차례인지만 골라 보게 한다(사이트가 바뀌어도
/// 관련 있는 칩 두 개만 다시 그려진다).

final class IsCurrentSiteTypeFamily extends $Family
    with $FunctionalFamilyOverride<bool, SiteType> {
  IsCurrentSiteTypeFamily._()
    : super(
        retry: null,
        name: r'isCurrentSiteTypeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 드로어 사이트 칩이 자기 차례인지만 골라 보게 한다(사이트가 바뀌어도
  /// 관련 있는 칩 두 개만 다시 그려진다).

  IsCurrentSiteTypeProvider call(SiteType siteType) =>
      IsCurrentSiteTypeProvider._(argument: siteType, from: this);

  @override
  String toString() => r'isCurrentSiteTypeProvider';
}

/// 드로어를 열고 닫기 위한 Scaffold 키.

@ProviderFor(mainScaffoldState)
final mainScaffoldStateProvider = MainScaffoldStateProvider._();

/// 드로어를 열고 닫기 위한 Scaffold 키.

final class MainScaffoldStateProvider
    extends
        $FunctionalProvider<
          GlobalKey<ScaffoldState>,
          GlobalKey<ScaffoldState>,
          GlobalKey<ScaffoldState>
        >
    with $Provider<GlobalKey<ScaffoldState>> {
  /// 드로어를 열고 닫기 위한 Scaffold 키.
  MainScaffoldStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mainScaffoldStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mainScaffoldStateHash();

  @$internal
  @override
  $ProviderElement<GlobalKey<ScaffoldState>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GlobalKey<ScaffoldState> create(Ref ref) {
    return mainScaffoldState(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GlobalKey<ScaffoldState> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GlobalKey<ScaffoldState>>(value),
    );
  }
}

String _$mainScaffoldStateHash() => r'e08ed879718fe9af8a42c31c3df1fbd7c053b5eb';

/// 드로어가 열려 있는지. 뒤로가기로 드로어부터 닫기 위해 들고 있는다.

@ProviderFor(MainSidebarNotifier)
final mainSidebarProvider = MainSidebarNotifierProvider._();

/// 드로어가 열려 있는지. 뒤로가기로 드로어부터 닫기 위해 들고 있는다.
final class MainSidebarNotifierProvider
    extends $NotifierProvider<MainSidebarNotifier, bool> {
  /// 드로어가 열려 있는지. 뒤로가기로 드로어부터 닫기 위해 들고 있는다.
  MainSidebarNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mainSidebarProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mainSidebarNotifierHash();

  @$internal
  @override
  MainSidebarNotifier create() => MainSidebarNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$mainSidebarNotifierHash() =>
    r'7f9b142f25e4d7e9ecb95319fb517a947530b27d';

/// 드로어가 열려 있는지. 뒤로가기로 드로어부터 닫기 위해 들고 있는다.

abstract class _$MainSidebarNotifier extends $Notifier<bool> {
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

/// 하단 탭 인덱스(0: 내 게시판, 1: 스크랩, 2: 설정).

@ProviderFor(MainTabIndex)
final mainTabIndexProvider = MainTabIndexProvider._();

/// 하단 탭 인덱스(0: 내 게시판, 1: 스크랩, 2: 설정).
final class MainTabIndexProvider extends $NotifierProvider<MainTabIndex, int> {
  /// 하단 탭 인덱스(0: 내 게시판, 1: 스크랩, 2: 설정).
  MainTabIndexProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mainTabIndexProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mainTabIndexHash();

  @$internal
  @override
  MainTabIndex create() => MainTabIndex();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$mainTabIndexHash() => r'815006204bd34ad8aaa78f2b949274b7f3978342';

/// 하단 탭 인덱스(0: 내 게시판, 1: 스크랩, 2: 설정).

abstract class _$MainTabIndex extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// 메인 화면 '편집 모드' 토글. 켜져 있을 때만 드래그 핸들과 삭제 버튼이
/// 노출된다(평소엔 탭으로 게시판 이동).

@ProviderFor(MainEditMode)
final mainEditModeProvider = MainEditModeProvider._();

/// 메인 화면 '편집 모드' 토글. 켜져 있을 때만 드래그 핸들과 삭제 버튼이
/// 노출된다(평소엔 탭으로 게시판 이동).
final class MainEditModeProvider extends $NotifierProvider<MainEditMode, bool> {
  /// 메인 화면 '편집 모드' 토글. 켜져 있을 때만 드래그 핸들과 삭제 버튼이
  /// 노출된다(평소엔 탭으로 게시판 이동).
  MainEditModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mainEditModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mainEditModeHash();

  @$internal
  @override
  MainEditMode create() => MainEditMode();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$mainEditModeHash() => r'4b6311091e551f80de168789bf93cdd113c3dc26';

/// 메인 화면 '편집 모드' 토글. 켜져 있을 때만 드래그 핸들과 삭제 버튼이
/// 노출된다(평소엔 탭으로 게시판 이동).

abstract class _$MainEditMode extends $Notifier<bool> {
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

/// 내 게시판 검색창이 열려 있는지.

@ProviderFor(MainSearchOpen)
final mainSearchOpenProvider = MainSearchOpenProvider._();

/// 내 게시판 검색창이 열려 있는지.
final class MainSearchOpenProvider
    extends $NotifierProvider<MainSearchOpen, bool> {
  /// 내 게시판 검색창이 열려 있는지.
  MainSearchOpenProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mainSearchOpenProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mainSearchOpenHash();

  @$internal
  @override
  MainSearchOpen create() => MainSearchOpen();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$mainSearchOpenHash() => r'b932e6370cb5aded664f4987cbffeaf23978f567';

/// 내 게시판 검색창이 열려 있는지.

abstract class _$MainSearchOpen extends $Notifier<bool> {
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

/// 내 게시판 검색어. 담은 게시판이 수십 개가 되면 스크롤·빠른 이동보다
/// 두 글자 입력이 빠르다.

@ProviderFor(MainSearchQuery)
final mainSearchQueryProvider = MainSearchQueryProvider._();

/// 내 게시판 검색어. 담은 게시판이 수십 개가 되면 스크롤·빠른 이동보다
/// 두 글자 입력이 빠르다.
final class MainSearchQueryProvider
    extends $NotifierProvider<MainSearchQuery, String> {
  /// 내 게시판 검색어. 담은 게시판이 수십 개가 되면 스크롤·빠른 이동보다
  /// 두 글자 입력이 빠르다.
  MainSearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mainSearchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mainSearchQueryHash();

  @$internal
  @override
  MainSearchQuery create() => MainSearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$mainSearchQueryHash() => r'826e60070e9bc5cced1cc3d332a7297b485411b6';

/// 내 게시판 검색어. 담은 게시판이 수십 개가 되면 스크롤·빠른 이동보다
/// 두 글자 입력이 빠르다.

abstract class _$MainSearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// 접어둔 카페 소구획 키 집합. 그룹 접힘과 같이 앱을 다시 켜도 유지된다.

@ProviderFor(CollapsedSubSections)
final collapsedSubSectionsProvider = CollapsedSubSectionsProvider._();

/// 접어둔 카페 소구획 키 집합. 그룹 접힘과 같이 앱을 다시 켜도 유지된다.
final class CollapsedSubSectionsProvider
    extends $NotifierProvider<CollapsedSubSections, Set<String>> {
  /// 접어둔 카페 소구획 키 집합. 그룹 접힘과 같이 앱을 다시 켜도 유지된다.
  CollapsedSubSectionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'collapsedSubSectionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$collapsedSubSectionsHash();

  @$internal
  @override
  CollapsedSubSections create() => CollapsedSubSections();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<String>>(value),
    );
  }
}

String _$collapsedSubSectionsHash() =>
    r'a8d5d5c90de5b21c97c3656faded0e5f898f6455';

/// 접어둔 카페 소구획 키 집합. 그룹 접힘과 같이 앱을 다시 켜도 유지된다.

abstract class _$CollapsedSubSections extends $Notifier<Set<String>> {
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
