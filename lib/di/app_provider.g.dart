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

@ProviderFor(getAppVersion)
const getAppVersionProvider = GetAppVersionProvider._();

final class GetAppVersionProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  const GetAppVersionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getAppVersionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getAppVersionHash();

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    return getAppVersion(ref);
  }
}

String _$getAppVersionHash() => r'c4281fce8377945fd7409c9eca1fb5f423da0eff';

@ProviderFor(clearData)
const clearDataProvider = ClearDataProvider._();

final class ClearDataProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  const ClearDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clearDataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clearDataHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return clearData(ref);
  }
}

String _$clearDataHash() => r'b0a541fc4f6aa6a9fbb014c67f22badd76ecc31c';

@ProviderFor(appRouter)
const appRouterProvider = AppRouterProvider._();

final class AppRouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  const AppRouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appRouterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appRouterHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return appRouter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$appRouterHash() => r'6e80798fefc7837b3278f71bd5114ae75c827c0a';

@ProviderFor(openUrl)
const openUrlProvider = OpenUrlFamily._();

final class OpenUrlProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  const OpenUrlProvider._({
    required OpenUrlFamily super.from,
    required (BuildContext, String) super.argument,
  }) : super(
         retry: null,
         name: r'openUrlProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$openUrlHash();

  @override
  String toString() {
    return r'openUrlProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    final argument = this.argument as (BuildContext, String);
    return openUrl(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is OpenUrlProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$openUrlHash() => r'8fc2a4ef65c3d799dd7f0d605fc435703d43bda9';

final class OpenUrlFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<bool>, (BuildContext, String)> {
  const OpenUrlFamily._()
    : super(
        retry: null,
        name: r'openUrlProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  OpenUrlProvider call(BuildContext context, String url) =>
      OpenUrlProvider._(argument: (context, url), from: this);

  @override
  String toString() => r'openUrlProvider';
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
    r'493e95ef209dea93230a9a1a99d33b9c16512e5e';

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
