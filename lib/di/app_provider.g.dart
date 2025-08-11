// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(CurrentSiteTypeNotifier)
const currentSiteTypeNotifierProvider = CurrentSiteTypeNotifierProvider._();

final class CurrentSiteTypeNotifierProvider
    extends $NotifierProvider<CurrentSiteTypeNotifier, SiteType> {
  const CurrentSiteTypeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentSiteTypeNotifierProvider',
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
const readableStateNotifierProvider = ReadableStateNotifierProvider._();

final class ReadableStateNotifierProvider
    extends $NotifierProvider<ReadableStateNotifier, int> {
  const ReadableStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'readableStateNotifierProvider',
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

String _$getAppVersionHash() => r'1a8aa3b2a8533b27f91dcf846a37fb098b0673b8';

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

@ProviderFor(showToast)
const showToastProvider = ShowToastFamily._();

final class ShowToastProvider extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  const ShowToastProvider._({
    required ShowToastFamily super.from,
    required (String, BuildContext) super.argument,
  }) : super(
         retry: null,
         name: r'showToastProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$showToastHash();

  @override
  String toString() {
    return r'showToastProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    final argument = this.argument as (String, BuildContext);
    return showToast(ref, argument.$1, argument.$2);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ShowToastProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$showToastHash() => r'38e03d8486b2e54b92b29cbe5d6e3211f7b4e71a';

final class ShowToastFamily extends $Family
    with $FunctionalFamilyOverride<void, (String, BuildContext)> {
  const ShowToastFamily._()
    : super(
        retry: null,
        name: r'showToastProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ShowToastProvider call(String message, BuildContext context) =>
      ShowToastProvider._(argument: (message, context), from: this);

  @override
  String toString() => r'showToastProvider';
}

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

String _$appRouterHash() => r'fff3f2857065d9454c5cd1625db3b5e6377fe411';

@ProviderFor(openBrowserByUrl)
const openBrowserByUrlProvider = OpenBrowserByUrlFamily._();

final class OpenBrowserByUrlProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  const OpenBrowserByUrlProvider._({
    required OpenBrowserByUrlFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'openBrowserByUrlProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$openBrowserByUrlHash();

  @override
  String toString() {
    return r'openBrowserByUrlProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    final argument = this.argument as String;
    return openBrowserByUrl(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is OpenBrowserByUrlProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$openBrowserByUrlHash() => r'db746ea383f5f88500a430c3e3529eab3d97d5d9';

final class OpenBrowserByUrlFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<bool>, String> {
  const OpenBrowserByUrlFamily._()
    : super(
        retry: null,
        name: r'openBrowserByUrlProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  OpenBrowserByUrlProvider call(String url) =>
      OpenBrowserByUrlProvider._(argument: url, from: this);

  @override
  String toString() => r'openBrowserByUrlProvider';
}

@ProviderFor(shareUrl)
const shareUrlProvider = ShareUrlFamily._();

final class ShareUrlProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  const ShareUrlProvider._({
    required ShareUrlFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'shareUrlProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$shareUrlHash();

  @override
  String toString() {
    return r'shareUrlProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    final argument = this.argument as String;
    return shareUrl(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ShareUrlProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$shareUrlHash() => r'ca62d08b9c54745db177a4ae0f5b11c82a472e18';

final class ShareUrlFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<bool>, String> {
  const ShareUrlFamily._()
    : super(
        retry: null,
        name: r'shareUrlProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ShareUrlProvider call(String url) =>
      ShareUrlProvider._(argument: url, from: this);

  @override
  String toString() => r'shareUrlProvider';
}

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

  static const $allTransitiveDependencies0 = _isImageUrlProvider;

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

String _$openUrlHash() => r'41295218d6ea91bda7c36e29bb298c287a6fb1ec';

final class OpenUrlFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<bool>, (BuildContext, String)> {
  const OpenUrlFamily._()
    : super(
        retry: null,
        name: r'openUrlProvider',
        dependencies: const <ProviderOrFamily>[_isImageUrlProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          OpenUrlProvider.$allTransitiveDependencies0,
        ],
        isAutoDispose: true,
      );

  OpenUrlProvider call(BuildContext context, String url) =>
      OpenUrlProvider._(argument: (context, url), from: this);

  @override
  String toString() => r'openUrlProvider';
}

@ProviderFor(_isImageUrl)
const _isImageUrlProvider = _IsImageUrlFamily._();

final class _IsImageUrlProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  const _IsImageUrlProvider._({
    required _IsImageUrlFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'_isImageUrlProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$_isImageUrlHash();

  @override
  String toString() {
    return r'_isImageUrlProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    final argument = this.argument as String;
    return _isImageUrl(ref, argument);
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
    return other is _IsImageUrlProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$_isImageUrlHash() => r'c1900604e1db0e98de79c598b4ec322d221645af';

final class _IsImageUrlFamily extends $Family
    with $FunctionalFamilyOverride<bool, String> {
  const _IsImageUrlFamily._()
    : super(
        retry: null,
        name: r'_isImageUrlProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  _IsImageUrlProvider call(String url) =>
      _IsImageUrlProvider._(argument: url, from: this);

  @override
  String toString() => r'_isImageUrlProvider';
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

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
