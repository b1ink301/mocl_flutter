// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(isCurrentSiteType)
final isCurrentSiteTypeProvider = IsCurrentSiteTypeFamily._();

final class IsCurrentSiteTypeProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
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

String _$isCurrentSiteTypeHash() => r'83cebea6efe00c23a93e714427deb038c92e3766';

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

  IsCurrentSiteTypeProvider call(SiteType siteType) =>
      IsCurrentSiteTypeProvider._(argument: siteType, from: this);

  @override
  String toString() => r'isCurrentSiteTypeProvider';
}

@ProviderFor(mainScaffoldState)
final mainScaffoldStateProvider = MainScaffoldStateProvider._();

final class MainScaffoldStateProvider
    extends
        $FunctionalProvider<
          GlobalKey<ScaffoldState>,
          GlobalKey<ScaffoldState>,
          GlobalKey<ScaffoldState>
        >
    with $Provider<GlobalKey<ScaffoldState>> {
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

/// 메인 화면 '편집 모드' 토글. 켜져 있을 때만 드래그 핸들과 그룹/항목 편집
/// 버튼이 노출된다(평소엔 탭으로 게시판 이동).

@ProviderFor(MainEditMode)
final mainEditModeProvider = MainEditModeProvider._();

/// 메인 화면 '편집 모드' 토글. 켜져 있을 때만 드래그 핸들과 그룹/항목 편집
/// 버튼이 노출된다(평소엔 탭으로 게시판 이동).
final class MainEditModeProvider extends $NotifierProvider<MainEditMode, bool> {
  /// 메인 화면 '편집 모드' 토글. 켜져 있을 때만 드래그 핸들과 그룹/항목 편집
  /// 버튼이 노출된다(평소엔 탭으로 게시판 이동).
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

/// 메인 화면 '편집 모드' 토글. 켜져 있을 때만 드래그 핸들과 그룹/항목 편집
/// 버튼이 노출된다(평소엔 탭으로 게시판 이동).

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

@ProviderFor(MainSidebarNotifier)
final mainSidebarProvider = MainSidebarNotifierProvider._();

final class MainSidebarNotifierProvider
    extends $NotifierProvider<MainSidebarNotifier, bool> {
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
    r'8ab2b984d8c127bb979cba3161477a432e07d68c';

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
