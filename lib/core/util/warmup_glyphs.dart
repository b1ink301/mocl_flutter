import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../config/mocl_text_styles.dart';

class Glyphs {
  const Glyphs._();

  static Future<void> warmUpGlyphs({
    required List<String> targets,
    required TextStyle textStyle,
  }) async {
    for (var text in targets) {
      final painter = TextPainter(
        text: TextSpan(text: text, style: textStyle),
        textDirection: TextDirection.ltr,
      );

      // 1. 레이아웃 계산 (CPU 단계)
      painter.layout();

      // 2. 가상 캔버스에 그리기 (GPU/Raster 캐시 등록 단계)
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);

      // 여기서 실제로 그려야 Glyph가 캐싱됩니다.
      painter.paint(canvas, Offset.zero);

      // 마무리 (메모리 해제)
      recorder.endRecording().dispose();
    }
  }

  /// 자주 쓰이는 한글/라틴 글리프를 미리 렌더링해 GPU glyph atlas 를 예열한다.
  /// 스크롤 중 새 글자 등장 시 발생하는 `CreateGlyphAtlas` 스파이크를 줄인다.
  ///
  /// 11k+ 음절을 한 번에 layout 하면 height 가 거대해져 메모리/시간 비용이 크므로,
  /// 청크 단위로 잘라서 처리하고 매 청크 사이에 yield 한다.
  static Future<void> warmupKoreanGlyphs(
    AppTextStyles textStyles, {
    bool Function()? shouldAbort, // 중단 여부를 확인할 콜백 추가
  }) async {
    // 현대 한글 음절 전체 (가~힣)
    final buf = StringBuffer();
    for (int code = 0xAC00; code <= 0xD7A3; code++) {
      buf.writeCharCode(code);
    }
    // 자주 쓰이는 라틴 + 숫자 + 기호
    buf.write(
      ' 0123456789abcdefghijklmnopqrstuvwxyz'
      'ABCDEFGHIJKLMNOPQRSTUVWXYZ.,!?·"\'()[]{}-_/',
    );
    final text = buf.toString();

    final styles = <TextStyle>[
      // 실제 앱에서 사용하는 스타일과 동일하게
      textStyles.titleTextStyle,
      textStyles.smallTextStyle,
      // textStyles.badgeTextStyle,
    ];

    const int chunkSize = 150; // 청크당 문자 수 (작을수록 한 번에 점유하는 UI 시간 짧음)
    const double maxWidth = 2048; // layout 최대 너비

    for (final style in styles) {
      for (int start = 0; start < text.length; start += chunkSize) {
        // 1. 루프 시작 시점에 체크
        if (shouldAbort != null && shouldAbort()) return;

        final end = (start + chunkSize) > text.length
            ? text.length
            : (start + chunkSize);
        final chunk = text.substring(start, end);

        // idle 우선순위로 예약 → 사용자 인터랙션/스크롤/애니메이션 중에는 대기.
        // 한 청크의 layout/paint 가 끝나야 다음이 시작되며, 그 사이 프레임 워크가
        // 더 중요한 작업을 처리할 수 있다.
        await SchedulerBinding.instance.scheduleTask<void>(() async {
          final tp = TextPainter(
            text: TextSpan(text: chunk, style: style),
            textDirection: TextDirection.ltr,
          )..layout(maxWidth: maxWidth);

          final recorder = PictureRecorder();
          final canvas = Canvas(recorder);
          tp.paint(canvas, Offset.zero);
          final picture = recorder.endRecording();

          // 실제 텍스트 영역에 맞춰 rasterize 해야 glyph 가 atlas 에 업로드됨.
          // 1x1 로 하면 Impeller 가 화면 밖 draw 를 컬링해 워밍업 효과가 사라진다.
          final int w = tp.width.ceil().clamp(1, 4096);
          final int h = tp.height.ceil().clamp(1, 4096);
          final image = await picture.toImage(w, h);
          image.dispose();
          picture.dispose();
          tp.dispose();
        }, Priority.idle);
      }
    }
  }
}
