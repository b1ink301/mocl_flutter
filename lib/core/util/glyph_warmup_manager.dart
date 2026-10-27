import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/core/util/mocl_logger.dart';
import 'package:mocl_flutter/core/util/warmup_glyphs.dart';

import '../../config/mocl_text_styles.dart';

class GlyphWarmupManager._() with WidgetsBindingObserver {
  static final GlyphWarmupManager instance = GlyphWarmupManager._();

  DateTime? backgroundedAt;
  bool _stopRequested = false; // 중지 요청 플래그 추가

  /// 실행 세대. 새 워밍업이 시작되면 이전 세대는 다음 청크에서 스스로 멈춘다.
  /// (폰트 크기 변경으로 dispose → init 이 연달아 오는 경우 등)
  int _generation = 0;
  late AppTextStyles _styles;

  void init(AppTextStyles styles) {
    _styles = styles;
    // 직전 dispose 가 남긴 중지 요청을 풀어야 새 스타일로 다시 예열된다.
    _stopRequested = false;
    WidgetsBinding.instance.addObserver(this);
    // 호출 측(AppWidget)이 PostFrame + delay 후 호출하므로 바로 시작.
    _runWarmup();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    MoclLogger.d(
      () => 'didChangeAppLifecycleState=$state',
      tag: 'GlyphWarmupManager',
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
    // 부팅 직후엔 lifecycleState 가 null 일 수 있으므로 명시적 paused/detached 만 차단.
    final lifecycle = WidgetsBinding.instance.lifecycleState;
    if (lifecycle == AppLifecycleState.paused ||
        lifecycle == AppLifecycleState.detached) {
      return;
    }
    final int generation = ++_generation;

    MoclLogger.d(() => '_runWarmup#1 start', tag: 'GlyphWarmupManager');

    final double dpr =
        WidgetsBinding
            .instance
            .platformDispatcher
            .implicitView
            ?.devicePixelRatio ??
        1.0;

    await Glyphs.warmupKoreanGlyphs(
      _warmupStyles(_styles),
      devicePixelRatio: dpr,
      shouldAbort: () => _stopRequested || generation != _generation,
    );

    MoclLogger.d(() => '_runWarmup#2 end', tag: 'GlyphWarmupManager');
  }

  /// 목록 · 상세에서 한글이 실제로 그려지는 (크기, 굵기) 조합.
  ///
  /// atlas 는 색과 무관하게 (폰트, 크기, 굵기) 로 구분되므로 그 기준으로
  /// 중복을 걸러낸다. 큰 제목(24px)은 글자 하나가 atlas 를 크게 차지해
  /// 예열하면 오히려 atlas 재생성을 앞당길 수 있어 제외한다.
  static List<TextStyle> _warmupStyles(AppTextStyles s) {
    final candidates = <TextStyle>[
      // 목록 제목 · 상세 본문/댓글
      s.titleTextStyle,
      s.readTitleTextStyle,
      // 작성자 메타 줄의 기본 스타일
      s.smallTextStyle,
      s.readSmallTextStyle,
      // AuthorInfoText: 닉네임(w500) · 시간ㆍ조회수(w400, -1.4px)
      for (final base in [s.smallTextStyle, s.readSmallTextStyle]) ...[
        base.copyWith(fontWeight: FontWeight.w500),
        base.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: (base.fontSize ?? 14.0) - 1.4,
        ),
      ],
    ];

    final seen = <(String?, double?, FontWeight)>{};
    return [
      for (final style in candidates)
        if (seen.add((
          style.fontFamily,
          style.fontSize,
          style.fontWeight ?? FontWeight.w400,
        )))
          style,
    ];
  }

  void dispose() {
    _stopRequested = true;
    WidgetsBinding.instance.removeObserver(this);

    MoclLogger.d(() => 'dispose', tag: 'GlyphWarmupManager');
  }
}
