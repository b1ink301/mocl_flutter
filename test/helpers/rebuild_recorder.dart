import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// 위젯 리빌드를 프로덕션 코드 수정 없이 계측한다.
///
/// Flutter 는 `Element.rebuild()` 안에서 [debugOnRebuildDirtyWidget] 훅을
/// assert 블록으로 호출한다(framework.dart). 테스트는 debug 모드로 돌기 때문에
/// 이 훅만 잡아두면 트리 전체의 리빌드를 위젯 타입별로 셀 수 있다.
/// (DevTools 의 'Widget rebuild stats' 와 같은 소스)
///
/// - **rebuild**: 이미 존재하던 Element 가 다시 build 된 경우
/// - **mount**: Element 가 새로 만들어져 첫 build 된 경우(= 재생성/re-inflate)
///
/// 두 값을 구분하는 이유: 트리 구조가 바뀌어 서브트리가 unmount → inflate 되는
/// 회귀(예: AppBar 의 bottom 슬롯이 bare ↔ Opacity 로 바뀌는 경우)는 rebuild 가
/// 아니라 mount 로 나타나기 때문이다.
///
/// ```dart
/// final rec = RebuildRecorder.attach();
/// await tester.pumpWidget(...);
/// await tester.pumpAndSettle();
/// rec.clearCounts();          // 최초 마운트 비용은 기준선에서 제외
/// await scrollCycles(tester);
/// rec.expectNoRebuild(const ['MyAppBar', 'MyRow']);
/// ```
class RebuildRecorder {
  RebuildRecorder();

  /// 계측을 시작하고 테스트 종료 시 자동으로 해제한다.
  /// (`testWidgets` 본문에서만 호출 — `addTearDown` 이 필요하다)
  factory RebuildRecorder.attach() {
    final RebuildRecorder recorder = RebuildRecorder()..start();
    addTearDown(recorder.stop);
    return recorder;
  }

  final Map<String, int> _rebuilds = <String, int>{};
  final Map<String, int> _mounts = <String, int>{};

  /// 이미 첫 build 를 마친 Element 집합. Element 는 == 를 재정의하지 않으므로
  /// 동일성(identity) 비교로 동작한다.
  final Set<Element> _seen = <Element>{};

  RebuildDirtyWidgetCallback? _previous;
  bool _active = false;

  void start() {
    if (_active) return;
    _previous = debugOnRebuildDirtyWidget;
    debugOnRebuildDirtyWidget = _record;
    _active = true;
  }

  void stop() {
    if (!_active) return;
    debugOnRebuildDirtyWidget = _previous;
    _previous = null;
    _active = false;
  }

  void _record(Element element, bool builtOnce) {
    // `builtOnce` 는 debugPrintRebuildDirtyWidgets 가 켜져 있을 때만 갱신되므로
    // 신뢰할 수 없다. Element 동일성으로 직접 판정한다.
    final String name = element.widget.runtimeType.toString();
    if (_seen.add(element)) {
      _mounts[name] = (_mounts[name] ?? 0) + 1;
    } else {
      _rebuilds[name] = (_rebuilds[name] ?? 0) + 1;
    }
  }

  /// 카운터만 초기화한다(Element 이력은 유지 → 이후의 첫 build 는 '재생성'으로 집계).
  void clearCounts() {
    _rebuilds.clear();
    _mounts.clear();
  }

  int rebuilds(String widgetName) => _rebuilds[widgetName] ?? 0;

  int mounts(String widgetName) => _mounts[widgetName] ?? 0;

  /// rebuild + mount 합계. "이 위젯의 build() 가 몇 번 돌았나"에 해당한다.
  int builds(String widgetName) => rebuilds(widgetName) + mounts(widgetName);

  Map<String, int> get rebuildsByWidget => Map<String, int>.unmodifiable(_rebuilds);

  Map<String, int> get mountsByWidget => Map<String, int>.unmodifiable(_mounts);

  /// 이름이 [pattern] 에 매칭되는 리빌드만 추린다.
  Map<String, int> rebuildsMatching(Pattern pattern) => <String, int>{
    for (final MapEntry<String, int> e in _rebuilds.entries)
      if (_matches(pattern, e.key)) e.key: e.value,
  };

  Map<String, int> mountsMatching(Pattern pattern) => <String, int>{
    for (final MapEntry<String, int> e in _mounts.entries)
      if (_matches(pattern, e.key)) e.key: e.value,
  };

  static bool _matches(Pattern pattern, String input) =>
      pattern.allMatches(input).any((Match m) => m.start == 0 && m.end == input.length);

  /// [names] 중 하나라도 리빌드/재생성되면 실패한다.
  ///
  /// [allowMounts] 를 켜면 '새로 마운트되는 것'은 허용한다. 스크롤로 화면에
  /// 새로 진입하는 리스트 행처럼 마운트가 정상인 위젯에 사용한다.
  void expectNoRebuild(
    Iterable<String> names, {
    String? reason,
    bool allowMounts = false,
  }) {
    final Map<String, String> violations = <String, String>{};
    for (final String name in names) {
      final int r = rebuilds(name);
      final int m = allowMounts ? 0 : mounts(name);
      if (r > 0 || m > 0) {
        violations[name] = 'rebuild $r회, 재생성(mount) ${mounts(name)}회';
      }
    }
    if (violations.isNotEmpty) {
      fail(
        '${reason ?? '리빌드되지 않아야 하는 위젯이 리빌드됨'}\n'
        '${violations.entries.map((e) => '  - ${e.key}: ${e.value}').join('\n')}\n\n'
        '${report()}',
      );
    }
  }

  /// [name] 이 최소 1회(또는 정확히 [times] 회) 리빌드되었는지 확인한다.
  /// 테스트 자체가 계측되고 있는지 검증하는 sanity check 로 쓴다.
  void expectRebuild(String name, {int? times, String? reason}) {
    final int actual = builds(name);
    if (times == null) {
      expect(
        actual,
        greaterThan(0),
        reason: reason ?? '$name 이 리빌드될 것으로 예상했지만 0회 (계측 대상이 트리에 없을 수 있음)\n${report()}',
      );
    } else {
      expect(actual, times, reason: reason ?? '$name build 횟수 불일치\n${report()}');
    }
  }

  /// 사람이 읽을 수 있는 상위 리빌드 목록.
  String report({int limit = 25, Pattern? only}) {
    Map<String, int> rebuilds = only == null ? _rebuilds : rebuildsMatching(only);
    Map<String, int> mounts = only == null ? _mounts : mountsMatching(only);

    final Set<String> names = <String>{...rebuilds.keys, ...mounts.keys};
    final List<String> sorted = names.toList()
      ..sort((a, b) {
        final int byRebuild = (rebuilds[b] ?? 0).compareTo(rebuilds[a] ?? 0);
        if (byRebuild != 0) return byRebuild;
        return (mounts[b] ?? 0).compareTo(mounts[a] ?? 0);
      });

    final StringBuffer buffer = StringBuffer('── 리빌드 리포트 (rebuild / mount) ──\n');
    if (sorted.isEmpty) {
      buffer.writeln('  (없음)');
      return buffer.toString();
    }
    for (final String name in sorted.take(limit)) {
      buffer.writeln('  ${(rebuilds[name] ?? 0).toString().padLeft(4)} / '
          '${(mounts[name] ?? 0).toString().padLeft(4)}  $name');
    }
    if (sorted.length > limit) {
      buffer.writeln('  ... 외 ${sorted.length - limit}종');
    }
    return buffer.toString();
  }

  /// 디버깅용. 실패 원인을 찾을 때 테스트에 임시로 넣어 쓴다.
  void printReport({int limit = 25, Pattern? only}) {
    // ignore: avoid_print
    print(report(limit: limit, only: only));
  }
}

/// 실제 손가락 스크롤처럼 **프레임 단위로 끊어서** 드래그한다.
///
/// `tester.drag()` 는 포인터 이벤트를 한 번에 보내고 프레임을 진행하지 않기
/// 때문에, 레이아웃이 도는 시점에는 이미 포인터가 떨어져
/// `userScrollDirection == idle` 이 된다. 그러면 floating 앱바는 재등장 조건
/// (`allowFloatingExpansion`, rendering/sliver_persistent_header.dart)을 만족하지
/// 못해 화면 중간에서는 다시 나타나지 않는다.
/// → 앱바 숨김/보임을 계측하려면 반드시 이 함수를 쓸 것.
///
/// [dy] 가 음수면 위로 밀어 올려(스크롤 오프셋 증가) 앱바를 숨기고,
/// 양수면 아래로 당겨(오프셋 감소) 앱바를 다시 노출시킨다.
Future<void> scrollBy(
  WidgetTester tester,
  double dy, {
  Finder? scrollable,
  int? steps,
}) async {
  final Finder target = scrollable ?? find.byType(Scrollable).first;
  // 한 스텝이 터치 슬롭(kDragSlopDefault)보다 커야 첫 프레임부터 스크롤이 시작된다.
  // 기본값은 스텝당 약 40px.
  final int stepCount = steps ?? (dy.abs() / 40).ceil().clamp(2, 60);
  assert(
    dy.abs() / stepCount > kDragSlopDefault,
    '스텝당 이동량($dy/$stepCount)이 터치 슬롭($kDragSlopDefault)보다 커야 한다',
  );

  final TestGesture gesture = await tester.startGesture(tester.getCenter(target));
  final Offset step = Offset(0, dy / stepCount);
  for (int i = 0; i < stepCount; i++) {
    await gesture.moveBy(step);
    await tester.pump(const Duration(milliseconds: 16));
  }
  await gesture.up();
  await tester.pumpAndSettle();
}

/// floating 앱바가 숨겨졌다 다시 나타나는 사이클을 반복한다.
///
/// 스크롤 위젯을 [scrollable] 로 지정하지 않으면 트리의 첫 [Scrollable] 을 쓴다.
Future<void> scrollCycles(
  WidgetTester tester, {
  int times = 3,
  double distance = 400,
  Finder? scrollable,
}) async {
  final Finder target = scrollable ?? find.byType(Scrollable).first;
  for (int i = 0; i < times; i++) {
    await scrollBy(tester, -distance, scrollable: target);
    await scrollBy(tester, distance, scrollable: target);
  }
}
