import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/core/util/mocl_logger.dart';
import 'package:mocl_flutter/core/util/warmup_glyphs.dart';

import '../../config/mocl_text_styles.dart';

class GlyphWarmupManager._() with WidgetsBindingObserver {
  static final GlyphWarmupManager instance = GlyphWarmupManager._();

  DateTime? backgroundedAt;
  bool _isWarmingUp = false;
  bool _stopRequested = false; // 중지 요청 플래그 추가
  late AppTextStyles _styles;

  void init(AppTextStyles styles) {
    _styles = styles;
    WidgetsBinding.instance.addObserver(this);
    // 호출 측(AppWidget)이 PostFrame + delay 후 호출하므로 바로 시작.
    _runWarmup();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    MoclLogger.logWithTag(
      'GlyphWarmupManager',
      'didChangeAppLifecycleState=$state',
    );
    if (state == AppLifecycleState.resumed) {
      final bg = backgroundedAt;
      if (bg != null && DateTime.now().difference(bg).inSeconds > 60) {
        _stopRequested = false; // 다시 시작할 수 있도록 초기화
        _runWarmup();
      }
    } else if (state == AppLifecycleState.paused) {
      backgroundedAt = DateTime.now();
      _stopRequested = true; // 중지 요청
    }
  }

  Future<void> _runWarmup() async {
    if (_isWarmingUp) return;
    // 부팅 직후엔 lifecycleState 가 null 일 수 있으므로 명시적 paused/detached 만 차단.
    final lifecycle = WidgetsBinding.instance.lifecycleState;
    if (lifecycle == AppLifecycleState.paused ||
        lifecycle == AppLifecycleState.detached) {
      return;
    }
    _isWarmingUp = true;

    MoclLogger.logWithTag('GlyphWarmupManager', '_runWarmup#1 start');

    final styles = <TextStyle>[
      // 실제 앱에서 사용하는 스타일과 동일하게
      _styles.titleTextStyle,
      _styles.smallTextStyle,
    ];

    // 이전에 만든 warmupKoreanGlyphs 함수 호출
    await Glyphs.warmupKoreanGlyphs(styles, shouldAbort: () => _stopRequested);

    _isWarmingUp = false;

    MoclLogger.logWithTag('GlyphWarmupManager', '_runWarmup#2 end');
  }

  void dispose() {
    _stopRequested = true;
    WidgetsBinding.instance.removeObserver(this);

    MoclLogger.logWithTag('GlyphWarmupManager', 'dispose');
  }
}
