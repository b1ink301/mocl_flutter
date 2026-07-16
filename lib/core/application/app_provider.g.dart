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
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SiteType, SiteType>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SiteType, SiteType>,
              SiteType,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
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
        isAutoDispose: true,
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
    r'65f77bdab3ef6f14fbbf91035f236ddb67fa0293';

abstract class _$ReadableStateNotifier extends $Notifier<int> {
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

/// 영속화된 테마 모드(시스템/라이트/다크). `AppWidget`의 themeMode 에 연결된다.

@ProviderFor(ThemeModeNotifier)
final themeModeProvider = ThemeModeNotifierProvider._();

/// 영속화된 테마 모드(시스템/라이트/다크). `AppWidget`의 themeMode 에 연결된다.
final class ThemeModeNotifierProvider
    extends $NotifierProvider<ThemeModeNotifier, ThemeMode> {
  /// 영속화된 테마 모드(시스템/라이트/다크). `AppWidget`의 themeMode 에 연결된다.
  ThemeModeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeModeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeModeNotifierHash();

  @$internal
  @override
  ThemeModeNotifier create() => ThemeModeNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeMode>(value),
    );
  }
}

String _$themeModeNotifierHash() => r'a4a1d8a684e1349bdb3aeec0318aff6e6d9f5316';

/// 영속화된 테마 모드(시스템/라이트/다크). `AppWidget`의 themeMode 에 연결된다.

abstract class _$ThemeModeNotifier extends $Notifier<ThemeMode> {
  ThemeMode build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ThemeMode, ThemeMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ThemeMode, ThemeMode>,
              ThemeMode,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// 시스템 밝기. 루트에서 `AppWidget`이 Theme 변경에 맞춰 갱신한다.

@ProviderFor(CurrentBrightness)
final currentBrightnessProvider = CurrentBrightnessProvider._();

/// 시스템 밝기. 루트에서 `AppWidget`이 Theme 변경에 맞춰 갱신한다.
final class CurrentBrightnessProvider
    extends $NotifierProvider<CurrentBrightness, Brightness> {
  /// 시스템 밝기. 루트에서 `AppWidget`이 Theme 변경에 맞춰 갱신한다.
  CurrentBrightnessProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentBrightnessProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentBrightnessHash();

  @$internal
  @override
  CurrentBrightness create() => CurrentBrightness();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Brightness value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Brightness>(value),
    );
  }
}

String _$currentBrightnessHash() => r'6894fb32c0edaa0ac93da2ee1774aa6dca5971be';

/// 시스템 밝기. 루트에서 `AppWidget`이 Theme 변경에 맞춰 갱신한다.

abstract class _$CurrentBrightness extends $Notifier<Brightness> {
  Brightness build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Brightness, Brightness>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Brightness, Brightness>,
              Brightness,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// 영속화된 폰트 크기 델타(step 단위).
/// ProviderScope와 무관하게 앱 전역에서 공유된다.

@ProviderFor(FontSizeDelta)
final fontSizeDeltaProvider = FontSizeDeltaProvider._();

/// 영속화된 폰트 크기 델타(step 단위).
/// ProviderScope와 무관하게 앱 전역에서 공유된다.
final class FontSizeDeltaProvider
    extends $NotifierProvider<FontSizeDelta, double> {
  /// 영속화된 폰트 크기 델타(step 단위).
  /// ProviderScope와 무관하게 앱 전역에서 공유된다.
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

String _$fontSizeDeltaHash() => r'5445c4f4fd981df26caf8a72a8d45b617d8c01ef';

/// 영속화된 폰트 크기 델타(step 단위).
/// ProviderScope와 무관하게 앱 전역에서 공유된다.

abstract class _$FontSizeDelta extends $Notifier<double> {
  double build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<double, double>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<double, double>,
              double,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// 폰트 스케일이 적용된 앱 텍스트 스타일.
/// 밝기/델타 변화에 따라 자동 재계산된다.

@ProviderFor(AppTextStylesFontSizeNotifier)
final appTextStylesFontSizeProvider = AppTextStylesFontSizeNotifierProvider._();

/// 폰트 스케일이 적용된 앱 텍스트 스타일.
/// 밝기/델타 변화에 따라 자동 재계산된다.
final class AppTextStylesFontSizeNotifierProvider
    extends $NotifierProvider<AppTextStylesFontSizeNotifier, AppTextStyles> {
  /// 폰트 스케일이 적용된 앱 텍스트 스타일.
  /// 밝기/델타 변화에 따라 자동 재계산된다.
  AppTextStylesFontSizeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appTextStylesFontSizeProvider',
        isAutoDispose: false,
        dependencies: <ProviderOrFamily>[
          currentBrightnessProvider,
          fontSizeDeltaProvider,
        ],
        $allTransitiveDependencies: <ProviderOrFamily>[
          AppTextStylesFontSizeNotifierProvider.$allTransitiveDependencies0,
          AppTextStylesFontSizeNotifierProvider.$allTransitiveDependencies1,
        ],
      );

  static final $allTransitiveDependencies0 = currentBrightnessProvider;
  static final $allTransitiveDependencies1 = fontSizeDeltaProvider;

  @override
  String debugGetCreateSourceHash() => _$appTextStylesFontSizeNotifierHash();

  @$internal
  @override
  AppTextStylesFontSizeNotifier create() => AppTextStylesFontSizeNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppTextStyles value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppTextStyles>(value),
    );
  }
}

String _$appTextStylesFontSizeNotifierHash() =>
    r'ce62c6fbecd729646f09eee72822150dc9f20c20';

/// 폰트 스케일이 적용된 앱 텍스트 스타일.
/// 밝기/델타 변화에 따라 자동 재계산된다.

abstract class _$AppTextStylesFontSizeNotifier
    extends $Notifier<AppTextStyles> {
  AppTextStyles build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AppTextStyles, AppTextStyles>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppTextStyles, AppTextStyles>,
              AppTextStyles,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// 앱바 타이틀 스타일(폰트 크기 반영). Paper 테마에서 앱바는 밝은 배경 +
/// 잉크 텍스트라 별도 색 지정 없이 기본 잉크색을 굵게 쓴다.

@ProviderFor(appbarTextStyle)
final appbarTextStyleProvider = AppbarTextStyleProvider._();

/// 앱바 타이틀 스타일(폰트 크기 반영). Paper 테마에서 앱바는 밝은 배경 +
/// 잉크 텍스트라 별도 색 지정 없이 기본 잉크색을 굵게 쓴다.

final class AppbarTextStyleProvider
    extends $FunctionalProvider<TextStyle, TextStyle, TextStyle>
    with $Provider<TextStyle> {
  /// 앱바 타이틀 스타일(폰트 크기 반영). Paper 테마에서 앱바는 밝은 배경 +
  /// 잉크 텍스트라 별도 색 지정 없이 기본 잉크색을 굵게 쓴다.
  AppbarTextStyleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appbarTextStyleProvider',
        isAutoDispose: false,
        dependencies: <ProviderOrFamily>[appTextStylesFontSizeProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          AppbarTextStyleProvider.$allTransitiveDependencies0,
          AppbarTextStyleProvider.$allTransitiveDependencies1,
          AppbarTextStyleProvider.$allTransitiveDependencies2,
        ],
      );

  static final $allTransitiveDependencies0 = appTextStylesFontSizeProvider;
  static final $allTransitiveDependencies1 =
      AppTextStylesFontSizeNotifierProvider.$allTransitiveDependencies0;
  static final $allTransitiveDependencies2 =
      AppTextStylesFontSizeNotifierProvider.$allTransitiveDependencies1;

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

String _$appbarTextStyleHash() => r'0fcdbf7ae43262ea80b412c8da3a30fa49928792';
