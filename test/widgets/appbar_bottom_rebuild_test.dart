import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/core/presentation/widgets/appbar_dual_text_widget.dart';

/// AppBar 의 bottom 슬롯은 bottomOpacity 가 1.0 ↔ <1.0 을 오갈 때
/// bare ↔ Opacity(bottom) 으로 트리 구조가 바뀌어(app_bar.dart) 서브트리가
/// deactivate/activate 되고, Directionality 등 상속 의존성이 있는 하위 위젯
/// (Padding/Row 포함)이 앱바 숨김/보임마다 리빌드/재생성된다.
/// AppbarDualTextWidget 은 실제 콘텐츠를 flexibleSpace 하단에 배치해 이를
/// 회피한다 — 이 테스트는 그 회귀를 감지한다.
void main() {
  testWidgets('앱바 숨김/보임 반복에도 확장영역(bottom)이 재생성/리빌드되지 않는다', (tester) async {
    final _Counts counts = _Counts();

    await tester.pumpWidget(_buildApp(counts));
    await tester.pumpAndSettle();

    expect(counts.inits, 1, reason: '초기 mount 는 1회여야 한다');
    final int buildsAfterFirstFrame = counts.builds;

    // 앱바 숨김/보임 사이클 3회 (bottomOpacity 1.0 경계를 왕복)
    for (int i = 0; i < 3; i++) {
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -400));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(CustomScrollView), const Offset(0, 400));
      await tester.pumpAndSettle();
    }

    expect(counts.inits, 1, reason: '숨김/보임 반복 중 재생성(remount)되면 안 된다');
    expect(
      counts.builds,
      buildsAfterFirstFrame,
      reason: '숨김/보임 반복 중 내부 위젯이 리빌드되면 안 된다',
    );
  });

  testWidgets('flexibleSpace 로 옮긴 확장영역이 여전히 터치 가능하다', (tester) async {
    final _Counts counts = _Counts();

    await tester.pumpWidget(_buildApp(counts));
    await tester.pumpAndSettle();

    await tester.tap(find.text('probe'));
    expect(counts.taps, 1, reason: 'flexibleSpace 의 헤더 버튼이 탭을 받아야 한다');
  });
}

Widget _buildApp(_Counts counts) => MaterialApp(
  home: Scaffold(
    body: CustomScrollView(
      slivers: [
        AppbarDualTextWidget(
          title: 'title',
          smallTitle: 'small',
          titleStyle: const TextStyle(fontSize: 18),
          smallTitleStyle: const TextStyle(fontSize: 11),
          bottom: _ProbeBar(counts: counts),
        ),
        SliverList.builder(
          itemCount: 100,
          itemBuilder: (context, index) =>
              SizedBox(height: 48, child: Text('item $index')),
        ),
      ],
    ),
  ),
);

class _Counts {
  int inits = 0;
  int builds = 0;
  int taps = 0;
}

/// DetailHeaderBar 와 같은 Padding > Row 구조의 빌드/마운트/탭 계측 프로브.
class _ProbeBar extends StatefulWidget implements PreferredSizeWidget {
  final _Counts counts;

  const _ProbeBar({super.key, required this.counts});

  @override
  Size get preferredSize => const Size.fromHeight(40);

  @override
  State<_ProbeBar> createState() => _ProbeBarState();
}

class _ProbeBarState extends State<_ProbeBar> {
  @override
  void initState() {
    super.initState();
    widget.counts.inits++;
  }

  @override
  Widget build(BuildContext context) {
    widget.counts.builds++;
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => widget.counts.taps++,
            child: const Text('probe'),
          ),
        ],
      ),
    );
  }
}
