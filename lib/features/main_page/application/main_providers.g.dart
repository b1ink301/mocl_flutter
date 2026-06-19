// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MainItemsNotifier)
final mainItemsProvider = MainItemsNotifierProvider._();

final class MainItemsNotifierProvider
    extends $AsyncNotifierProvider<MainItemsNotifier, List<MainItem>> {
  MainItemsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mainItemsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mainItemsNotifierHash();

  @$internal
  @override
  MainItemsNotifier create() => MainItemsNotifier();
}

String _$mainItemsNotifierHash() => r'3af8ea7d2f7988029315558d4d643a8e582bf6f1';

abstract class _$MainItemsNotifier extends $AsyncNotifier<List<MainItem>> {
  FutureOr<List<MainItem>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<MainItem>>, List<MainItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<MainItem>>, List<MainItem>>,
              AsyncValue<List<MainItem>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(mainTitle)
final mainTitleProvider = MainTitleProvider._();

final class MainTitleProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
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

String _$mainTitleHash() => r'e0b3513472862bfa8b45f23a70918377478b7c24';

@ProviderFor(showAddButton)
final showAddButtonProvider = ShowAddButtonProvider._();

final class ShowAddButtonProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  ShowAddButtonProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'showAddButtonProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$showAddButtonHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return showAddButton(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$showAddButtonHash() => r'049dd02547904e5016935ef608c2dd53dca3ff26';

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

@ProviderFor(setMainItems)
final setMainItemsProvider = SetMainItemsFamily._();

final class SetMainItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Either<Failure, List<int>>>,
          Either<Failure, List<int>>,
          FutureOr<Either<Failure, List<int>>>
        >
    with
        $FutureModifier<Either<Failure, List<int>>>,
        $FutureProvider<Either<Failure, List<int>>> {
  SetMainItemsProvider._({
    required SetMainItemsFamily super.from,
    required List<MainItem> super.argument,
  }) : super(
         retry: null,
         name: r'setMainItemsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$setMainItemsHash();

  @override
  String toString() {
    return r'setMainItemsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Either<Failure, List<int>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Either<Failure, List<int>>> create(Ref ref) {
    final argument = this.argument as List<MainItem>;
    return setMainItems(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SetMainItemsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$setMainItemsHash() => r'bd471882e9fa32aaca99b647ab03ea80205b31f5';

final class SetMainItemsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Either<Failure, List<int>>>,
          List<MainItem>
        > {
  SetMainItemsFamily._()
    : super(
        retry: null,
        name: r'setMainItemsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SetMainItemsProvider call(List<MainItem> list) =>
      SetMainItemsProvider._(argument: list, from: this);

  @override
  String toString() => r'setMainItemsProvider';
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

/// 메인 항목 '정렬 모드' 토글. 켜져 있을 때만 드래그 핸들이 노출되고
/// 드래그로 순서를 바꿀 수 있다(평소엔 탭으로 게시판 이동).

@ProviderFor(MainReorderMode)
final mainReorderModeProvider = MainReorderModeProvider._();

/// 메인 항목 '정렬 모드' 토글. 켜져 있을 때만 드래그 핸들이 노출되고
/// 드래그로 순서를 바꿀 수 있다(평소엔 탭으로 게시판 이동).
final class MainReorderModeProvider
    extends $NotifierProvider<MainReorderMode, bool> {
  /// 메인 항목 '정렬 모드' 토글. 켜져 있을 때만 드래그 핸들이 노출되고
  /// 드래그로 순서를 바꿀 수 있다(평소엔 탭으로 게시판 이동).
  MainReorderModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mainReorderModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mainReorderModeHash();

  @$internal
  @override
  MainReorderMode create() => MainReorderMode();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$mainReorderModeHash() => r'6f50304e1ddaeeeac19f36b258cf5f1c0aec4734';

/// 메인 항목 '정렬 모드' 토글. 켜져 있을 때만 드래그 핸들이 노출되고
/// 드래그로 순서를 바꿀 수 있다(평소엔 탭으로 게시판 이동).

abstract class _$MainReorderMode extends $Notifier<bool> {
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
    r'7cf94c97c85560c6689389f28a0d7eb385adf4c5';

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
