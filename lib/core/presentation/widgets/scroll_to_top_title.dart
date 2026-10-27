import 'package:material_ui/material_ui.dart';

/// 앱바 툴바 제목 자리. 탭하면 감싸고 있는 스크롤뷰를 맨 위로 올린다.
///
/// 메인 · 목록 · 상세가 같이 쓴다. 큰 제목 앱바는 floating 이라 역스크롤하면
/// 툴바만 내려오고, 상세의 작성자 헤더처럼 본문 맨 위에 있는 것은 끝까지
/// 올려야 보인다. 툴바를 한 번 탭해 바로 돌아가게 한다(iOS 상태바 탭과 같은 동작).
///
/// 제목 슬롯 전체(가로 남은 폭 · 툴바 높이)를 탭 영역으로 쓴다. 크럼브가
/// 짧거나 비어 있어도 툴바 빈 곳을 눌러 동작하게 하려는 것이다.
///
/// 앱바가 스크롤뷰 안의 sliver 라 [PrimaryScrollController] 는 쓸 수 없다
/// (ScrollView 가 자식에게 `PrimaryScrollController.none` 을 씌운다).
/// 가장 가까운 [Scrollable] 의 position 을 직접 움직인다.
class const ScrollToTopTitle({super.key, required final Widget child})
    extends StatelessWidget {
  /// 이보다 멀리(뷰포트 높이 배수) 내려가 있으면 먼저 가까이 점프한 뒤
  /// 애니메이션한다. 긴 본문을 처음부터 끝까지 애니메이션하면 지나가는
  /// 이미지 · 항목을 전부 다시 빌드 · 디코딩해 버벅인다.
  static const double _kJumpThresholdViewports = 3;

  static const Duration _kDuration = Duration(milliseconds: 300);

  void _scrollToTop(BuildContext context) {
    final ScrollPosition? position = Scrollable.maybeOf(context)?.position;
    if (position == null || position.pixels <= position.minScrollExtent) {
      return;
    }
    final double viewport = position.viewportDimension;
    if (position.pixels > viewport * _kJumpThresholdViewports) {
      position.jumpTo(position.minScrollExtent + viewport);
    }
    position.animateTo(
      position.minScrollExtent,
      duration: _kDuration,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () => _scrollToTop(context),
    child: SizedBox(
      width: double.infinity,
      height: kToolbarHeight,
      child: Align(alignment: AlignmentDirectional.centerStart, child: child),
    ),
  );
}
