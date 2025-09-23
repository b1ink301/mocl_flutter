// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CurrentSiteTypeNotifier)
const currentSiteTypeProvider = CurrentSiteTypeNotifierProvider._();

final class CurrentSiteTypeNotifierProvider
    extends $NotifierProvider<CurrentSiteTypeNotifier, SiteType> {
  const CurrentSiteTypeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentSiteTypeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentSiteTypeNotifierHash();

  @$internal
  @override
  CurrentSiteTypeNotifier create() => CurrentSiteTypeNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SiteType value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SiteType>(value),
    );
  }
}

String _$currentSiteTypeNotifierHash() =>
    r'c73bf72962d97791de69a72d75d769545797e8e7';

abstract class _$CurrentSiteTypeNotifier extends $Notifier<SiteType> {
  SiteType build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<SiteType, SiteType>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SiteType, SiteType>,
              SiteType,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ReadableStateNotifier)
const readableStateProvider = ReadableStateNotifierProvider._();

final class ReadableStateNotifierProvider
    extends $NotifierProvider<ReadableStateNotifier, int> {
  const ReadableStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'readableStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$readableStateNotifierHash();

  @$internal
  @override
  ReadableStateNotifier create() => ReadableStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$readableStateNotifierHash() =>
    r'b6d400867e7860fcfc2758c47d287b0bd013485e';

abstract class _$ReadableStateNotifier extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(appbarTextStyle)
const appbarTextStyleProvider = AppbarTextStyleProvider._();

final class AppbarTextStyleProvider
    extends $FunctionalProvider<TextStyle, TextStyle, TextStyle>
    with $Provider<TextStyle> {
  const AppbarTextStyleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appbarTextStyleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appbarTextStyleHash();

  @$internal
  @override
  $ProviderElement<TextStyle> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TextStyle create(Ref ref) {
    return appbarTextStyle(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TextStyle value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TextStyle>(value),
    );
  }
}

String _$appbarTextStyleHash() => r'831bec677d811438105caedd0b3152db2db72e02';

@ProviderFor(screenWidth)
const screenWidthProvider = ScreenWidthProvider._();

final class ScreenWidthProvider
    extends $FunctionalProvider<double, double, double>
    with $Provider<double> {
  const ScreenWidthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'screenWidthProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$screenWidthHash();

  @$internal
  @override
  $ProviderElement<double> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  double create(Ref ref) {
    return screenWidth(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double>(value),
    );
  }
}

String _$screenWidthHash() => r'f9429b6bf80fa9cf2ffb37cba2678dbfcafd523e';

@ProviderFor(appTextStyles)
const appTextStylesProvider = AppTextStylesProvider._();

final class AppTextStylesProvider
    extends $FunctionalProvider<AppTextStyles, AppTextStyles, AppTextStyles>
    with $Provider<AppTextStyles> {
  const AppTextStylesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appTextStylesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appTextStylesHash();

  @$internal
  @override
  $ProviderElement<AppTextStyles> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppTextStyles create(Ref ref) {
    return appTextStyles(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppTextStyles value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppTextStyles>(value),
    );
  }
}

String _$appTextStylesHash() => r'32605ed7bb94d2f39defcd0599f4fc86c90cb0a1';

@ProviderFor(AppTextStylesFontSizeNotifier)
const appTextStylesFontSizeProvider = AppTextStylesFontSizeNotifierProvider._();

final class AppTextStylesFontSizeNotifierProvider
    extends
        $NotifierProvider<AppTextStylesFontSizeNotifier, CurrentTextStyles> {
  const AppTextStylesFontSizeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appTextStylesFontSizeProvider',
        isAutoDispose: false,
        dependencies: const <ProviderOrFamily>[appTextStylesProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          AppTextStylesFontSizeNotifierProvider.$allTransitiveDependencies0,
        ],
      );

  static const $allTransitiveDependencies0 = appTextStylesProvider;

  @override
  String debugGetCreateSourceHash() => _$appTextStylesFontSizeNotifierHash();

  @$internal
  @override
  AppTextStylesFontSizeNotifier create() => AppTextStylesFontSizeNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CurrentTextStyles value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CurrentTextStyles>(value),
    );
  }
}

String _$appTextStylesFontSizeNotifierHash() =>
    r'be4778f121411c57280b45f6f3fa7c547cd2f4f2';

abstract class _$AppTextStylesFontSizeNotifier
    extends $Notifier<CurrentTextStyles> {
  CurrentTextStyles build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<CurrentTextStyles, CurrentTextStyles>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CurrentTextStyles, CurrentTextStyles>,
              CurrentTextStyles,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
