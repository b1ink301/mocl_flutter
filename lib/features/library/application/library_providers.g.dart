// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 보관함 탭에서 고른 칸. 앱을 다시 켜도 마지막에 본 칸을 연다(기본 스크랩).

@ProviderFor(LibrarySegmentNotifier)
final librarySegmentProvider = LibrarySegmentNotifierProvider._();

/// 보관함 탭에서 고른 칸. 앱을 다시 켜도 마지막에 본 칸을 연다(기본 스크랩).
final class LibrarySegmentNotifierProvider
    extends $NotifierProvider<LibrarySegmentNotifier, LibrarySegment> {
  /// 보관함 탭에서 고른 칸. 앱을 다시 켜도 마지막에 본 칸을 연다(기본 스크랩).
  LibrarySegmentNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'librarySegmentProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$librarySegmentNotifierHash();

  @$internal
  @override
  LibrarySegmentNotifier create() => LibrarySegmentNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LibrarySegment value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LibrarySegment>(value),
    );
  }
}

String _$librarySegmentNotifierHash() =>
    r'9d63a8c52c51f90e2f108428fa6fdb203d4a65fa';

/// 보관함 탭에서 고른 칸. 앱을 다시 켜도 마지막에 본 칸을 연다(기본 스크랩).

abstract class _$LibrarySegmentNotifier extends $Notifier<LibrarySegment> {
  LibrarySegment build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<LibrarySegment, LibrarySegment>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LibrarySegment, LibrarySegment>,
              LibrarySegment,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
