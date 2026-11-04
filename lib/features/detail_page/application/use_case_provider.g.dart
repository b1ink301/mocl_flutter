// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'use_case_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getDetail)
final getDetailProvider = GetDetailFamily._();

final class GetDetailProvider
    extends $FunctionalProvider<GetDetail, GetDetail, GetDetail>
    with $Provider<GetDetail> {
  GetDetailProvider._({
    required GetDetailFamily super.from,
    required SiteType super.argument,
  }) : super(
         retry: null,
         name: r'getDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getDetailHash();

  @override
  String toString() {
    return r'getDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<GetDetail> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetDetail create(Ref ref) {
    final argument = this.argument as SiteType;
    return getDetail(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetDetail value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetDetail>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getDetailHash() => r'7c70969bbd3ef88ed61a0d4fa80df24846ac8a52';

final class GetDetailFamily extends $Family
    with $FunctionalFamilyOverride<GetDetail, SiteType> {
  GetDetailFamily._()
    : super(
        retry: null,
        name: r'getDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetDetailProvider call(SiteType siteType) =>
      GetDetailProvider._(argument: siteType, from: this);

  @override
  String toString() => r'getDetailProvider';
}

@ProviderFor(setReadFlag)
final setReadFlagProvider = SetReadFlagFamily._();

final class SetReadFlagProvider
    extends $FunctionalProvider<SetReadFlag, SetReadFlag, SetReadFlag>
    with $Provider<SetReadFlag> {
  SetReadFlagProvider._({
    required SetReadFlagFamily super.from,
    required SiteType super.argument,
  }) : super(
         retry: null,
         name: r'setReadFlagProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$setReadFlagHash();

  @override
  String toString() {
    return r'setReadFlagProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<SetReadFlag> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SetReadFlag create(Ref ref) {
    final argument = this.argument as SiteType;
    return setReadFlag(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SetReadFlag value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SetReadFlag>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SetReadFlagProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$setReadFlagHash() => r'1ee13066c59948659ee6e990494fc77f360253c2';

final class SetReadFlagFamily extends $Family
    with $FunctionalFamilyOverride<SetReadFlag, SiteType> {
  SetReadFlagFamily._()
    : super(
        retry: null,
        name: r'setReadFlagProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SetReadFlagProvider call(SiteType siteType) =>
      SetReadFlagProvider._(argument: siteType, from: this);

  @override
  String toString() => r'setReadFlagProvider';
}

@ProviderFor(writeComment)
final writeCommentProvider = WriteCommentFamily._();

final class WriteCommentProvider
    extends $FunctionalProvider<WriteComment, WriteComment, WriteComment>
    with $Provider<WriteComment> {
  WriteCommentProvider._({
    required WriteCommentFamily super.from,
    required SiteType super.argument,
  }) : super(
         retry: null,
         name: r'writeCommentProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$writeCommentHash();

  @override
  String toString() {
    return r'writeCommentProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<WriteComment> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WriteComment create(Ref ref) {
    final argument = this.argument as SiteType;
    return writeComment(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WriteComment value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WriteComment>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is WriteCommentProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$writeCommentHash() => r'bd293b5a7c1eaf1b08f94bf8a18a944fe4cc3840';

final class WriteCommentFamily extends $Family
    with $FunctionalFamilyOverride<WriteComment, SiteType> {
  WriteCommentFamily._()
    : super(
        retry: null,
        name: r'writeCommentProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WriteCommentProvider call(SiteType siteType) =>
      WriteCommentProvider._(argument: siteType, from: this);

  @override
  String toString() => r'writeCommentProvider';
}

/// 이 사이트에서 앱으로 댓글을 쓸 수 있는지.
///
/// 저장소까지 만들면 로컬 DB 를 끌어오므로 API 객체에서 바로 읽는다.

@ProviderFor(supportsCommentWrite)
final supportsCommentWriteProvider = SupportsCommentWriteFamily._();

/// 이 사이트에서 앱으로 댓글을 쓸 수 있는지.
///
/// 저장소까지 만들면 로컬 DB 를 끌어오므로 API 객체에서 바로 읽는다.

final class SupportsCommentWriteProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// 이 사이트에서 앱으로 댓글을 쓸 수 있는지.
  ///
  /// 저장소까지 만들면 로컬 DB 를 끌어오므로 API 객체에서 바로 읽는다.
  SupportsCommentWriteProvider._({
    required SupportsCommentWriteFamily super.from,
    required SiteType super.argument,
  }) : super(
         retry: null,
         name: r'supportsCommentWriteProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$supportsCommentWriteHash();

  @override
  String toString() {
    return r'supportsCommentWriteProvider'
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
    return supportsCommentWrite(ref, argument);
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
    return other is SupportsCommentWriteProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$supportsCommentWriteHash() =>
    r'd2c455d4d7655cd29e3359d8c293a84300ebbcb7';

/// 이 사이트에서 앱으로 댓글을 쓸 수 있는지.
///
/// 저장소까지 만들면 로컬 DB 를 끌어오므로 API 객체에서 바로 읽는다.

final class SupportsCommentWriteFamily extends $Family
    with $FunctionalFamilyOverride<bool, SiteType> {
  SupportsCommentWriteFamily._()
    : super(
        retry: null,
        name: r'supportsCommentWriteProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 이 사이트에서 앱으로 댓글을 쓸 수 있는지.
  ///
  /// 저장소까지 만들면 로컬 DB 를 끌어오므로 API 객체에서 바로 읽는다.

  SupportsCommentWriteProvider call(SiteType siteType) =>
      SupportsCommentWriteProvider._(argument: siteType, from: this);

  @override
  String toString() => r'supportsCommentWriteProvider';
}
