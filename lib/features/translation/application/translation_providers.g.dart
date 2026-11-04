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
