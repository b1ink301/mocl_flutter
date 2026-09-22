import 'package:material_ui/material_ui.dart';

/// 메인 / 목록 / 상세 앱바의 확장 영역 큰 제목 치수.
///
/// 렌더(`LargeTitleFlexibleSpace`)와 높이 측정(`detailAppbarHeight`)이 **반드시
/// 같은 값**을 봐야 한다. 두 곳이 각자 숫자를 들고 있으면 제목이 툴바 위로
/// 삐져나오거나 아래가 뜨는데, 화면에서 눈으로만 잡히는 종류의 버그라
/// 값을 여기 한 곳에만 둔다.
const double kLargeTitleFontSize = 30.0;
const double kLargeTitleLineSpacing = 1.15;

/// 큰 제목 한 줄이 차지하는 세로 크기.
const double kLargeTitleLineHeight =
    kLargeTitleFontSize * kLargeTitleLineSpacing;

const double kLargeTitleStartInset = 16.0;
const double kLargeTitleEndInset = 4.0;

/// 제목 아래 여백(앱바 하단과의 간격).
const double kLargeTitleBottomSpace = 4.0;

/// 제목 위 여백(툴바와의 간격).
const double kLargeTitleTopSpace = 6.0;

const EdgeInsetsDirectional kLargeTitlePadding = EdgeInsetsDirectional.only(
  start: kLargeTitleStartInset,
  end: kLargeTitleEndInset,
  bottom: kLargeTitleBottomSpace,
);

/// 제목이 쓸 수 있는 폭을 구할 때 화면 폭에서 빼야 하는 값.
const double kLargeTitleHorizontalInset =
    kLargeTitleStartInset + kLargeTitleEndInset;

/// 큰 제목 스타일. 측정과 렌더가 같은 스타일을 써야 줄 수가 일치한다.
TextStyle largeTitleStyle(TextStyle base) => base.copyWith(
  fontSize: kLargeTitleFontSize,
  fontWeight: FontWeight.w800,
  height: kLargeTitleLineSpacing,
);

/// 제목 높이([textHeight])로부터 `SliverAppBar.expandedHeight` 를 구한다.
double largeTitleExpandedHeight(double textHeight) =>
    textHeight + kLargeTitleTopSpace + kLargeTitleBottomSpace + kToolbarHeight;

/// 한 줄짜리 제목(메인 · 목록)의 확장 높이.
final double kLargeTitleExpandedHeightSingleLine = largeTitleExpandedHeight(
  kLargeTitleLineHeight,
);

/// 상세 제목이 늘어날 수 있는 최대 줄 수.
const int kDetailTitleMaxLines = 3;

/// 툴바 크럼브(상위 경로) 규칙.
///
/// 큰 제목은 "지금 보고 있는 것"만 말한다. 그 위 어디에서 왔는지(사이트 ·
/// 게시판)는 이미 있는 툴바 줄에 작게 적는다. 확장 영역 높이를 한 픽셀도
/// 더 쓰지 않으면서 목록 · 상세가 같은 리듬을 갖게 하려는 것.
///
/// - 메인: 크럼브 없음 (최상위)
/// - 목록: `클리앙` · 큰 제목 = 게시판 이름
/// - 상세: `클리앙 › 모두의공원` · 큰 제목 = 글 제목
const String kAppbarCrumbSeparator = ' › ';

/// 크럼브를 뒤로가기 버튼 쪽으로 당기는 양.
///
/// AppBar 는 leading 을 폭 56 으로 묶는다. 그대로 두면 아이콘(오른쪽 끝 40)과
/// 글자 사이가 16 이나 벌어져 크럼브가 제목처럼 떠 보인다.
const double kAppbarCrumbTitleSpacing = -8.0;

/// 크럼브 스타일. 큰 제목과 싸우지 않도록 작은 본문 스타일(= 작성자 메타 줄과
/// 같은 크기 · 색)에 두께만 한 단계 올려 쓴다. 폰트 크기 설정은 [base] 가
/// 이미 반영하고 있으므로 여기서 크기를 고정하지 않는다.
TextStyle appbarCrumbStyle(TextStyle base) =>
    base.copyWith(fontWeight: FontWeight.w500);
