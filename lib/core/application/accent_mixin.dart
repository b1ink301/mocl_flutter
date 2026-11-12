import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/config/accent_palette.dart';

import 'accent_provider.dart';

export 'accent_provider.dart' show AccentMode, AccentSetting;

/// 강조색 조회(공통 mixin — 어느 화면이든 `with` 로 쓴다).
mixin class AppAccentState() {
  AccentSetting accentSettingState(WidgetRef ref) =>
      ref.watch(accentSettingProvider);

  /// 사이트 색 모드인지(목록 · 상세를 그 사이트 색으로 덮을지).
  bool siteAccentModeState(WidgetRef ref) =>
      ref.watch(accentSettingProvider.select((s) => s.mode == AccentMode.site));

  AccentColors appAccentState(WidgetRef ref) => ref.watch(appAccentProvider);
}

/// 강조색 바꾸기.
mixin class AppAccentEvent() {
  Future<void> selectAccentMode(WidgetRef ref, AccentMode mode) =>
      ref.read(accentSettingProvider.notifier).selectMode(mode);

  Future<void> selectCustomAccent(WidgetRef ref, int index) =>
      ref.read(accentSettingProvider.notifier).selectCustom(index);
}
