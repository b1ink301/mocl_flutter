// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 하단 탭 인덱스(0: 내 게시판, 1: 스크랩, 2: 설정).

@ProviderFor(MainTabIndex)
final mainTabIndexProvider = MainTabIndexProvider._();

/// 하단 탭 인덱스(0: 내 게시판, 1: 스크랩, 2: 설정).
final class MainTabIndexProvider extends $NotifierProvider<MainTabIndex, int> {
  /// 하단 탭 인덱스(0: 내 게시판, 1: 스크랩, 2: 설정).
  MainTabIndexProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mainTabIndexProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mainTabIndexHash();

  @$internal
  @override
  MainTabIndex create() => MainTabIndex();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$mainTabIndexHash() => r'815006204bd34ad8aaa78f2b949274b7f3978342';

/// 하단 탭 인덱스(0: 내 게시판, 1: 스크랩, 2: 설정).

abstract class _$MainTabIndex extends $Notifier<int> {
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

/// 메인 화면 '편집 모드' 토글. 켜져 있을 때만 드래그 핸들과 그룹/항목 편집
/// 버튼이 노출된다(평소엔 탭으로 게시판 이동).

@ProviderFor(MainEditMode)
final mainEditModeProvider = MainEditModeProvider._();

/// 메인 화면 '편집 모드' 토글. 켜져 있을 때만 드래그 핸들과 그룹/항목 편집
/// 버튼이 노출된다(평소엔 탭으로 게시판 이동).
final class MainEditModeProvider extends $NotifierProvider<MainEditMode, bool> {
  /// 메인 화면 '편집 모드' 토글. 켜져 있을 때만 드래그 핸들과 그룹/항목 편집
  /// 버튼이 노출된다(평소엔 탭으로 게시판 이동).
  MainEditModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mainEditModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mainEditModeHash();

  @$internal
  @override
  MainEditMode create() => MainEditMode();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$mainEditModeHash() => r'4b6311091e551f80de168789bf93cdd113c3dc26';

/// 메인 화면 '편집 모드' 토글. 켜져 있을 때만 드래그 핸들과 그룹/항목 편집
/// 버튼이 노출된다(평소엔 탭으로 게시판 이동).

abstract class _$MainEditMode extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
