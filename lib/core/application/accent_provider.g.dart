// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accent_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 설정 "강조색". 부팅 때 바로 쓰도록 동기 SharedPreferences 에서 읽는다(코랄로 떴다가 바뀌지 않게).

@ProviderFor(AccentSettingNotifier)
final accentSettingProvider = AccentSettingNotifierProvider._();

/// 설정 "강조색". 부팅 때 바로 쓰도록 동기 SharedPreferences 에서 읽는다(코랄로 떴다가 바뀌지 않게).
final class AccentSettingNotifierProvider
    extends $NotifierProvider<AccentSettingNotifier, AccentSetting> {
  /// 설정 "강조색". 부팅 때 바로 쓰도록 동기 SharedPreferences 에서 읽는다(코랄로 떴다가 바뀌지 않게).
  AccentSettingNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accentSettingProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accentSettingNotifierHash();

  @$internal
  @override
  AccentSettingNotifier create() => AccentSettingNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccentSetting value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AccentSetting>(value),
    );
  }
}

String _$accentSettingNotifierHash() =>
    r'9cd3ebfcec95edd89c5fc657615f6d25549c7ffe';

/// 설정 "강조색". 부팅 때 바로 쓰도록 동기 SharedPreferences 에서 읽는다(코랄로 떴다가 바뀌지 않게).

abstract class _$AccentSettingNotifier extends $Notifier<AccentSetting> {
  AccentSetting build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AccentSetting, AccentSetting>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AccentSetting, AccentSetting>,
              AccentSetting,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// 앱 전체(테마)의 강조색. 사이트 색 모드면 드로어에서 고른 사이트 색.

@ProviderFor(appAccent)
final appAccentProvider = AppAccentProvider._();

/// 앱 전체(테마)의 강조색. 사이트 색 모드면 드로어에서 고른 사이트 색.

final class AppAccentProvider
    extends $FunctionalProvider<AccentColors, AccentColors, AccentColors>
    with $Provider<AccentColors> {
  /// 앱 전체(테마)의 강조색. 사이트 색 모드면 드로어에서 고른 사이트 색.
  AppAccentProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appAccentProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appAccentHash();

  @$internal
  @override
  $ProviderElement<AccentColors> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AccentColors create(Ref ref) {
    return appAccent(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccentColors value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AccentColors>(value),
    );
  }
}

String _$appAccentHash() => r'19f470313575f281bcea4b09e7352accc9e1bee0';
