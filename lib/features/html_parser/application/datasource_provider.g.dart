// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'datasource_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(_clienParser)
const _clienParserProvider = _ClienParserFamily._();

final class _ClienParserProvider
    extends
        $FunctionalProvider<
          (BaseParser, BaseApi),
          (BaseParser, BaseApi),
          (BaseParser, BaseApi)
        >
    with $Provider<(BaseParser, BaseApi)> {
  const _ClienParserProvider._({
    required _ClienParserFamily super.from,
    required bool super.argument,
  }) : super(
         retry: null,
         name: r'_clienParserProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$_clienParserHash();

  @override
  String toString() {
    return r'_clienParserProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<(BaseParser, BaseApi)> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  (BaseParser, BaseApi) create(Ref ref) {
    final argument = this.argument as bool;
    return _clienParser(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue((BaseParser, BaseApi) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<(BaseParser, BaseApi)>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is _ClienParserProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$_clienParserHash() => r'3805cc0a5f78bf4f254a006b014055d98d4ffd97';

final class _ClienParserFamily extends $Family
    with $FunctionalFamilyOverride<(BaseParser, BaseApi), bool> {
  const _ClienParserFamily._()
    : super(
        retry: null,
        name: r'_clienParserProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  _ClienParserProvider call(bool isShowNickImage) =>
      _ClienParserProvider._(argument: isShowNickImage, from: this);

  @override
  String toString() => r'_clienParserProvider';
}

@ProviderFor(_damoangParser)
const _damoangParserProvider = _DamoangParserFamily._();

final class _DamoangParserProvider
    extends
        $FunctionalProvider<
          (BaseParser, BaseApi),
          (BaseParser, BaseApi),
          (BaseParser, BaseApi)
        >
    with $Provider<(BaseParser, BaseApi)> {
  const _DamoangParserProvider._({
    required _DamoangParserFamily super.from,
    required bool super.argument,
  }) : super(
         retry: null,
         name: r'_damoangParserProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$_damoangParserHash();

  @override
  String toString() {
    return r'_damoangParserProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<(BaseParser, BaseApi)> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  (BaseParser, BaseApi) create(Ref ref) {
    final argument = this.argument as bool;
    return _damoangParser(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue((BaseParser, BaseApi) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<(BaseParser, BaseApi)>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is _DamoangParserProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$_damoangParserHash() => r'30b98e6a4f509bb79568bcfd0c2558825710604e';

final class _DamoangParserFamily extends $Family
    with $FunctionalFamilyOverride<(BaseParser, BaseApi), bool> {
  const _DamoangParserFamily._()
    : super(
        retry: null,
        name: r'_damoangParserProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  _DamoangParserProvider call(bool isShowNickImage) =>
      _DamoangParserProvider._(argument: isShowNickImage, from: this);

  @override
  String toString() => r'_damoangParserProvider';
}

@ProviderFor(_meecoParser)
const _meecoParserProvider = _MeecoParserFamily._();

final class _MeecoParserProvider
    extends
        $FunctionalProvider<
          (BaseParser, BaseApi),
          (BaseParser, BaseApi),
          (BaseParser, BaseApi)
        >
    with $Provider<(BaseParser, BaseApi)> {
  const _MeecoParserProvider._({
    required _MeecoParserFamily super.from,
    required bool super.argument,
  }) : super(
         retry: null,
         name: r'_meecoParserProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$_meecoParserHash();

  @override
  String toString() {
    return r'_meecoParserProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<(BaseParser, BaseApi)> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  (BaseParser, BaseApi) create(Ref ref) {
    final argument = this.argument as bool;
    return _meecoParser(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue((BaseParser, BaseApi) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<(BaseParser, BaseApi)>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is _MeecoParserProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$_meecoParserHash() => r'34a6096b158e5ccffd106dc27d887395e491a092';

final class _MeecoParserFamily extends $Family
    with $FunctionalFamilyOverride<(BaseParser, BaseApi), bool> {
  const _MeecoParserFamily._()
    : super(
        retry: null,
        name: r'_meecoParserProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  _MeecoParserProvider call(bool isShowNickImage) =>
      _MeecoParserProvider._(argument: isShowNickImage, from: this);

  @override
  String toString() => r'_meecoParserProvider';
}

@ProviderFor(_naverCafeParser)
const _naverCafeParserProvider = _NaverCafeParserFamily._();

final class _NaverCafeParserProvider
    extends
        $FunctionalProvider<
          (BaseParser, BaseApi),
          (BaseParser, BaseApi),
          (BaseParser, BaseApi)
        >
    with $Provider<(BaseParser, BaseApi)> {
  const _NaverCafeParserProvider._({
    required _NaverCafeParserFamily super.from,
    required bool super.argument,
  }) : super(
         retry: null,
         name: r'_naverCafeParserProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$_naverCafeParserHash();

  @override
  String toString() {
    return r'_naverCafeParserProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<(BaseParser, BaseApi)> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  (BaseParser, BaseApi) create(Ref ref) {
    final argument = this.argument as bool;
    return _naverCafeParser(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue((BaseParser, BaseApi) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<(BaseParser, BaseApi)>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is _NaverCafeParserProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$_naverCafeParserHash() => r'd49d7b92c83778dec8a7011268b0b6e17daf5ade';

final class _NaverCafeParserFamily extends $Family
    with $FunctionalFamilyOverride<(BaseParser, BaseApi), bool> {
  const _NaverCafeParserFamily._()
    : super(
        retry: null,
        name: r'_naverCafeParserProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  _NaverCafeParserProvider call(bool isShowNickImage) =>
      _NaverCafeParserProvider._(argument: isShowNickImage, from: this);

  @override
  String toString() => r'_naverCafeParserProvider';
}

@ProviderFor(_redditParser)
const _redditParserProvider = _RedditParserFamily._();

final class _RedditParserProvider
    extends
        $FunctionalProvider<
          (BaseParser, BaseApi),
          (BaseParser, BaseApi),
          (BaseParser, BaseApi)
        >
    with $Provider<(BaseParser, BaseApi)> {
  const _RedditParserProvider._({
    required _RedditParserFamily super.from,
    required bool super.argument,
  }) : super(
         retry: null,
         name: r'_redditParserProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$_redditParserHash();

  @override
  String toString() {
    return r'_redditParserProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<(BaseParser, BaseApi)> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  (BaseParser, BaseApi) create(Ref ref) {
    final argument = this.argument as bool;
    return _redditParser(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue((BaseParser, BaseApi) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<(BaseParser, BaseApi)>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is _RedditParserProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$_redditParserHash() => r'76707f2a6d56a31f7908cac04cafed59071515d1';

final class _RedditParserFamily extends $Family
    with $FunctionalFamilyOverride<(BaseParser, BaseApi), bool> {
  const _RedditParserFamily._()
    : super(
        retry: null,
        name: r'_redditParserProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  _RedditParserProvider call(bool isShowNickImage) =>
      _RedditParserProvider._(argument: isShowNickImage, from: this);

  @override
  String toString() => r'_redditParserProvider';
}

@ProviderFor(_theqooParser)
const _theqooParserProvider = _TheqooParserFamily._();

final class _TheqooParserProvider
    extends
        $FunctionalProvider<
          (BaseParser, BaseApi),
          (BaseParser, BaseApi),
          (BaseParser, BaseApi)
        >
    with $Provider<(BaseParser, BaseApi)> {
  const _TheqooParserProvider._({
    required _TheqooParserFamily super.from,
    required bool super.argument,
  }) : super(
         retry: null,
         name: r'_theqooParserProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$_theqooParserHash();

  @override
  String toString() {
    return r'_theqooParserProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<(BaseParser, BaseApi)> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  (BaseParser, BaseApi) create(Ref ref) {
    final argument = this.argument as bool;
    return _theqooParser(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue((BaseParser, BaseApi) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<(BaseParser, BaseApi)>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is _TheqooParserProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$_theqooParserHash() => r'980a34e5d1a2350fe1bdd07974c6a8b89b23c3a2';

final class _TheqooParserFamily extends $Family
    with $FunctionalFamilyOverride<(BaseParser, BaseApi), bool> {
  const _TheqooParserFamily._()
    : super(
        retry: null,
        name: r'_theqooParserProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  _TheqooParserProvider call(bool isShowNickImage) =>
      _TheqooParserProvider._(argument: isShowNickImage, from: this);

  @override
  String toString() => r'_theqooParserProvider';
}

@ProviderFor(currentParser)
const currentParserProvider = CurrentParserFamily._();

final class CurrentParserProvider
    extends
        $FunctionalProvider<
          (BaseParser, BaseApi),
          (BaseParser, BaseApi),
          (BaseParser, BaseApi)
        >
    with $Provider<(BaseParser, BaseApi)> {
  const CurrentParserProvider._({
    required CurrentParserFamily super.from,
    required SiteType super.argument,
  }) : super(
         retry: null,
         name: r'currentParserProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$currentParserHash();

  @override
  String toString() {
    return r'currentParserProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<(BaseParser, BaseApi)> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  (BaseParser, BaseApi) create(Ref ref) {
    final argument = this.argument as SiteType;
    return currentParser(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue((BaseParser, BaseApi) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<(BaseParser, BaseApi)>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CurrentParserProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$currentParserHash() => r'6ed842e5c0bbcd1aab5c91b094c244c61d1b1d8f';

final class CurrentParserFamily extends $Family
    with $FunctionalFamilyOverride<(BaseParser, BaseApi), SiteType> {
  const CurrentParserFamily._()
    : super(
        retry: null,
        name: r'currentParserProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CurrentParserProvider call(SiteType siteType) =>
      CurrentParserProvider._(argument: siteType, from: this);

  @override
  String toString() => r'currentParserProvider';
}
