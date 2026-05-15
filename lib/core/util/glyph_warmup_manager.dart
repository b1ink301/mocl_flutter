import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mocl_flutter/core/util/warmup_glyphs.dart';

import '../../config/mocl_text_styles.dart';

class GlyphWarmupManager with WidgetsBindingObserver {
  static final GlyphWarmupManager instance = GlyphWarmupManager._();

  GlyphWarmupManager._();

  bool _isWarmingUp = false;
  bool _stopRequested = false; // 중지 요청 플래그 추가
  late AppTextStyles _styles;

  void init(AppTextStyles styles) {
    _styles = styles;
    WidgetsBinding.instance.addObserver(this);
    // 앱 첫 실행 시 웜업
    _runWarmup();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _stopRequested = false; // 다시 시작할 수 있도록 초기화
      _runWarmup();
    } else if (state == AppLifecycleState.paused) {
      _stopRequested = true; // 중지 요청
    }
  }

  Future<void> _runWarmup() async {
    if (_isWarmingUp) return;
    _isWarmingUp = true;

    // 이전에 만든 warmupKoreanGlyphs 함수 호출
    await Glyphs.warmupKoreanGlyphs(_styles, shouldAbort: () => _stopRequested);

    _isWarmingUp = false;
  }

  void dispose() {
    _stopRequested = true;
    WidgetsBinding.instance.removeObserver(this);
  }
}
