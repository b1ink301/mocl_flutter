// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translation_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(translator)
final translatorProvider = TranslatorProvider._();

final class TranslatorProvider
    extends $FunctionalProvider<Translator, Translator, Translator>
    with $Provider<Translator> {
  TranslatorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'translatorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$translatorHash();

  @$internal
  @override
  $ProviderElement<Translator> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Translator create(Ref ref) {
    return translator(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Translator value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Translator>(value),
    );
  }
}

String _$translatorHash() => r'ba6c4904be3d873e7a1a4aa1013523048ea271b0';

/// 이 기기에서 번역을 쓸 수 있는지. 앱이 떠 있는 동안 바뀌지 않으므로 한 번만 묻는다.

@ProviderFor(translationAvailable)
final translationAvailableProvider = TranslationAvailableProvider._();

/// 이 기기에서 번역을 쓸 수 있는지. 앱이 떠 있는 동안 바뀌지 않으므로 한 번만 묻는다.

final class TranslationAvailableProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// 이 기기에서 번역을 쓸 수 있는지. 앱이 떠 있는 동안 바뀌지 않으므로 한 번만 묻는다.
  TranslationAvailableProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'translationAvailableProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$translationAvailableHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return translationAvailable(ref);
  }
}

String _$translationAvailableHash() =>
    r'd7bc69bf9c8010b486fb8312b9da23bf8dbe74d2';

/// 이 사이트에 번역 버튼을 둘지. 사이트가 켜 두었고(레딧) 기기가 지원해야 한다.
///
/// 저장소까지 만들면 로컬 DB 를 끌어오므로 파서에서 바로 읽는다.

@ProviderFor(siteTranslationSupported)
final siteTranslationSupportedProvider = SiteTranslationSupportedFamily._();

/// 이 사이트에 번역 버튼을 둘지. 사이트가 켜 두었고(레딧) 기기가 지원해야 한다.
///
/// 저장소까지 만들면 로컬 DB 를 끌어오므로 파서에서 바로 읽는다.

final class SiteTranslationSupportedProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// 이 사이트에 번역 버튼을 둘지. 사이트가 켜 두었고(레딧) 기기가 지원해야 한다.
  ///
  /// 저장소까지 만들면 로컬 DB 를 끌어오므로 파서에서 바로 읽는다.
  SiteTranslationSupportedProvider._({
    required SiteTranslationSupportedFamily super.from,
    required SiteType super.argument,
  }) : super(
         retry: null,
         name: r'siteTranslationSupportedProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$siteTranslationSupportedHash();

  @override
  String toString() {
    return r'siteTranslationSupportedProvider'
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
    return siteTranslationSupported(ref, argument);
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
    return other is SiteTranslationSupportedProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$siteTranslationSupportedHash() =>
    r'61313dfb67cb6f3472def0950f8574147bfbc862';

/// 이 사이트에 번역 버튼을 둘지. 사이트가 켜 두었고(레딧) 기기가 지원해야 한다.
///
/// 저장소까지 만들면 로컬 DB 를 끌어오므로 파서에서 바로 읽는다.

final class SiteTranslationSupportedFamily extends $Family
    with $FunctionalFamilyOverride<bool, SiteType> {
  SiteTranslationSupportedFamily._()
    : super(
        retry: null,
        name: r'siteTranslationSupportedProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 이 사이트에 번역 버튼을 둘지. 사이트가 켜 두었고(레딧) 기기가 지원해야 한다.
  ///
  /// 저장소까지 만들면 로컬 DB 를 끌어오므로 파서에서 바로 읽는다.

  SiteTranslationSupportedProvider call(SiteType siteType) =>
      SiteTranslationSupportedProvider._(argument: siteType, from: this);

  @override
  String toString() => r'siteTranslationSupportedProvider';
}

/// 목록 제목 번역 저장소. 앱이 떠 있는 동안 유지해서, 같은 제목은 게시판을
/// 다시 열거나 새로고침해도 다시 번역하지 않는다.

@ProviderFor(TitleTranslationsNotifier)
final titleTranslationsProvider = TitleTranslationsNotifierProvider._();

/// 목록 제목 번역 저장소. 앱이 떠 있는 동안 유지해서, 같은 제목은 게시판을
/// 다시 열거나 새로고침해도 다시 번역하지 않는다.
final class TitleTranslationsNotifierProvider
    extends $NotifierProvider<TitleTranslationsNotifier, TitleTranslations> {
  /// 목록 제목 번역 저장소. 앱이 떠 있는 동안 유지해서, 같은 제목은 게시판을
  /// 다시 열거나 새로고침해도 다시 번역하지 않는다.
  TitleTranslationsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'titleTranslationsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$titleTranslationsNotifierHash();

  @$internal
  @override
  TitleTranslationsNotifier create() => TitleTranslationsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TitleTranslations value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TitleTranslations>(value),
    );
  }
}

String _$titleTranslationsNotifierHash() =>
    r'af2f0ad062418f2288fc6c154a37f6dcdaf072f7';

/// 목록 제목 번역 저장소. 앱이 떠 있는 동안 유지해서, 같은 제목은 게시판을
/// 다시 열거나 새로고침해도 다시 번역하지 않는다.

abstract class _$TitleTranslationsNotifier
    extends $Notifier<TitleTranslations> {
  TitleTranslations build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<TitleTranslations, TitleTranslations>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TitleTranslations, TitleTranslations>,
              TitleTranslations,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
