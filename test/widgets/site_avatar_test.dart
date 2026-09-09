import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/presentation/widgets/site_avatar.dart';

/// 뽐뿌는 원본 파비콘이 16×15 밖에 없어 일부러 로고 에셋을 만들지 않았다.
/// 확대하면 뭉개지므로 사이트 이름 배지로 표시한다.
/// (`tool/fetch_site_icons.dart` 의 `_minSourceSize` 참고)
const Set<SiteType> _badgeOnly = <SiteType>{SiteType.ppomppu};

void main() {
  testWidgets('모든 사이트가 예외 없이 그려진다', (WidgetTester tester) async {
    for (final SiteType siteType in SiteType.values) {
      await tester.pumpWidget(
        MaterialApp(
          home: Center(child: SiteAvatar(siteType: siteType, radius: 13)),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        tester.takeException(),
        isNull,
        reason: '${siteType.name} 아이콘을 그리는 중 예외가 났다',
      );
      expect(find.byType(SiteAvatar), findsOneWidget);
    }
  });

  test('로고가 있는 사이트는 에셋이 실제로 디코딩된다', () async {
    // 에셋을 지우거나 pubspec 등록을 빠뜨리면 앱에서는 조용히 배지로 물러나
    // 눈치채기 어렵다. 여기서 잡는다.
    TestWidgetsFlutterBinding.ensureInitialized();

    for (final SiteType siteType in SiteType.values) {
      if (_badgeOnly.contains(siteType)) continue;

      final String path = 'assets/icons/${siteType.name}.png';
      final ByteData data = await rootBundle.load(path);
      final ui.Codec codec = await ui.instantiateImageCodec(
        data.buffer.asUint8List(),
      );
      final ui.FrameInfo frame = await codec.getNextFrame();

      expect(frame.image.width, 96, reason: '$path 의 가로 크기');
      expect(frame.image.height, 96, reason: '$path 의 세로 크기');
      frame.image.dispose();
      codec.dispose();
    }
  });

  test('배지로만 표시하는 사이트는 로고 에셋이 없다', () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    for (final SiteType siteType in _badgeOnly) {
      bool loaded;
      try {
        await rootBundle.load('assets/icons/${siteType.name}.png');
        loaded = true;
      } on Object catch (_) {
        loaded = false;
      }

      expect(
        loaded,
        isFalse,
        reason: '${siteType.name} 은 배지로 쓰기로 했는데 에셋이 남아 있다',
      );
    }
  });
}
