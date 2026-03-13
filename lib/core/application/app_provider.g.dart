// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CurrentSiteTypeNotifier)
final currentSiteTypeProvider = CurrentSiteTypeNotifierProvider._();

final class CurrentSiteTypeNotifierProvider
    extends $NotifierProvider<CurrentSiteTypeNotifier, SiteType> {
  CurrentSiteTypeNotifierProvider._()
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
    r'4ddd017b677cd41d51252aa6c9792989240f07b9';

abstract class _$CurrentSiteTypeNotifier extends $Notifier<SiteType> {
  SiteType build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SiteType, SiteType>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SiteType, SiteType>,
              SiteType,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(ReadableStateNotifier)
final readableStateProvider = ReadableStateNotifierProvider._();

final class ReadableStateNotifierProvider
    extends $NotifierProvider<ReadableStateNotifier, int> {
  ReadableStateNotifierProvider._()
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
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(appbarTextStyle)
final appbarTextStyleProvider = AppbarTextStyleProvider._();

final class AppbarTextStyleProvider
    extends $FunctionalProvider<TextStyle, TextStyle, TextStyle>
    with $Provider<TextStyle> {
  AppbarTextStyleProvider._()
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
final screenWidthProvider = ScreenWidthProvider._();

final class ScreenWidthProvider
    extends $FunctionalProvider<double, double, double>
    with $Provider<double> {
  ScreenWidthProvider._()
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
final appTextStylesProvider = AppTextStylesProvider._();

final class AppTextStylesProvider
    extends $FunctionalProvider<AppTextStyles, AppTextStyles, AppTextStyles>
    with $Provider<AppTextStyles> {
  AppTextStylesProvider._()
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

/// Global font size delta provider.
/// NOT dependent on scoped providers, so changes propagate across ALL
/// ProviderScopes (detail, list, main pages all share this instance).

@ProviderFor(FontSizeDelta)
final fontSizeDeltaProvider = FontSizeDeltaProvider._();

/// Global font size delta provider.
/// NOT dependent on scoped providers, so changes propagate across ALL
/// ProviderScopes (detail, list, main pages all share this instance).
final class FontSizeDeltaProvider
    extends $NotifierProvider<FontSizeDelta, double> {
  /// Global font size delta provider.
  /// NOT dependent on scoped providers, so changes propagate across ALL
  /// ProviderScopes (detail, list, main pages all share this instance).
  FontSizeDeltaProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fontSizeDeltaProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fontSizeDeltaHash();

  @$internal
  @override
  FontSizeDelta create() => FontSizeDelta();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double>(value),
    );
  }
}

String _$fontSizeDeltaHash() => r'2bf04fb22b96fab95b49b76535d47ee1b2917763';

/// Global font size delta provider.
/// NOT dependent on scoped providers, so changes propagate across ALL
/// ProviderScopes (detail, list, main pages all share this instance).

abstract class _$FontSizeDelta extends $Notifier<double> {
  double build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<double, double>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<double, double>,
              double,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(AppTextStylesFontSizeNotifier)
final appTextStylesFontSizeProvider = AppTextStylesFontSizeNotifierProvider._();

final class AppTextStylesFontSizeNotifierProvider
    extends
        $NotifierProvider<AppTextStylesFontSizeNotifier, CurrentTextStyles> {
  AppTextStylesFontSizeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appTextStylesFontSizeProvider',
        isAutoDispose: false,
        dependencies: <ProviderOrFamily>[
          appTextStylesProvider,
          fontSizeDeltaProvider,
        ],
        $allTransitiveDependencies: <ProviderOrFamily>[
          AppTextStylesFontSizeNotifierProvider.$allTransitiveDependencies0,
          AppTextStylesFontSizeNotifierProvider.$allTransitiveDependencies1,
        ],
      );

  static final $allTransitiveDependencies0 = appTextStylesProvider;
  static final $allTransitiveDependencies1 = fontSizeDeltaProvider;

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
    r'95299ba345948a04e09cb94d84dbd456ee189538';

abstract class _$AppTextStylesFontSizeNotifier
    extends $Notifier<CurrentTextStyles> {
  CurrentTextStyles build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<CurrentTextStyles, CurrentTextStyles>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CurrentTextStyles, CurrentTextStyles>,
              CurrentTextStyles,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
