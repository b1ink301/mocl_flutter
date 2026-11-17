import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';

/// 메인 / 목록 / 상세 앱바의 확장 영역 큰 제목 치수.
///
/// 렌더(`LargeTitleFlexibleSpace`)와 높이 측정(`detailAppbarHeight`)이 **반드시
/// 같은 값**을 봐야 한다. 두 곳이 각자 숫자를 들고 있으면 제목이 툴바 위로
/// 삐져나오거나 아래가 뜨는데, 화면에서 눈으로만 잡히는 종류의 버그라
/// 값을 여기 한 곳에만 둔다.
/// 큰 제목 기준 크기 · 줄높이(글자 크기 설정 0단계 28/34).
///
/// iOS Large Title 을 따른다: 굵고 촘촘한 제목을 목록 바로 위에 붙여 머리글처럼 읽히게 한다.
/// iOS 의 34pt 는 한글이 같은 크기 영문보다 크고 무거워 보여 줄였다. 30 도 2~5글자 게시판 이름이
/// 목록 행(16)을 누르는 덩어리로 보여 28 로 내렸다. 26 이면 상세 제목(24)과 구분이 흐려진다.
/// M3 Large(28/36 · w400 · 아래 28 · 펼침 152)는 위쪽을 넓게 써서 글이 주인공인 목록이
/// 한 줄 밀리고 제목이 떠 보여 쓰지 않는다(1.6.3 에서 절충형으로 써 본 뒤 되돌림).
const double kLargeTitleBaseFontSize = 28.0;
const double kLargeTitleLineSpacing = 34 / 28;

/// 큰 제목이 글자 크기 설정을 따라가는 비율. 본문이 1.1배면 제목은 1.05배.
///
/// 본문과 같은 비율로 키우면 큰 단계에서 제목이 지나치게 커지고(+10단계 42sp),
/// 고정이면 본문과 크기 차이가 사라진다(예전 24 고정: +10단계에서 본문과 같았다).
/// 큰 글자는 덜 키우는 Android 14 비선형 글꼴 배율과 같은 방향이다.
const double kLargeTitleScaleFollow = 0.5;

/// 큰 제목 앱바의 툴바 높이. 48 버튼이 들어가는 Android 기본 높이(iOS 44 보다 크다).
const double kLargeTitleToolbarHeight = 56.0;

const double kLargeTitleStartInset = 16.0;
const double kLargeTitleEndInset = 4.0;

/// 제목 아래 여백(앱바 하단과의 간격).
const double kLargeTitleBottomSpace = 8.0;

/// 제목 위 여백(툴바와의 간격).
const double kLargeTitleTopSpace = 0.0;

const EdgeInsetsDirectional kLargeTitlePadding = EdgeInsetsDirectional.only(
  top: kLargeTitleTopSpace,
  start: kLargeTitleStartInset,
  end: kLargeTitleEndInset,
  bottom: kLargeTitleBottomSpace,
);

/// 제목이 쓸 수 있는 폭을 구할 때 화면 폭에서 빼야 하는 값.
const double kLargeTitleHorizontalInset =
    kLargeTitleStartInset + kLargeTitleEndInset;

/// 본문 제목 글자 크기([bodyFontSize], 설정 배율 반영)에 맞춘 큰 제목 글자 크기.
/// [base] 는 0단계 크기(상세는 [kDetailTitleBaseFontSize]).
double largeTitleFontSize(
  double bodyFontSize, {
  double base = kLargeTitleBaseFontSize,
}) {
  final double factor = bodyFontSize / kAppTitleFontSize;
  return base * (1 + (factor - 1) * kLargeTitleScaleFollow);
}

/// 큰 제목 스타일. 측정과 렌더가 같은 스타일을 써야 줄 수가 일치한다.
/// [base] 는 글자 크기 설정이 반영된 목록 제목 스타일이다.
TextStyle largeTitleStyle(TextStyle base) => base.copyWith(
  fontSize: largeTitleFontSize(base.fontSize ?? kAppTitleFontSize),
  fontWeight: FontWeight.w700,
  height: kLargeTitleLineSpacing,
);

/// 상세 큰 제목(글 제목) 기준 크기 · 줄높이(0단계 24/30).
///
/// 글 제목은 사이트 · 게시판 이름과 달리 길어서 두세 줄이 흔하다. 홈 · 목록과 같은
/// 30 굵게면 세 줄에 화면 위쪽을 다 쓰고 무거워 한 단계 줄였다. 굵기 · 여백은 같다.
const double kDetailTitleBaseFontSize = 24.0;
const double kDetailTitleLineSpacing = 1.25;

/// 상세 큰 제목 스타일. 렌더(`DetailAppBar`)와 높이 측정(`detailAppbarHeight`)이 함께 쓴다.
TextStyle detailTitleStyle(TextStyle base) => base.copyWith(
  fontSize: largeTitleFontSize(
    base.fontSize ?? kAppTitleFontSize,
    base: kDetailTitleBaseFontSize,
  ),
  fontWeight: FontWeight.w700,
  height: kDetailTitleLineSpacing,
);

/// 큰 제목 한 줄이 차지하는 세로 크기.
double largeTitleLineHeight(TextStyle style) =>
    (style.fontSize ?? kLargeTitleBaseFontSize) *
    (style.height ?? kLargeTitleLineSpacing);

/// 제목 높이([textHeight])로부터 `SliverAppBar.expandedHeight` 를 구한다.
double largeTitleExpandedHeight(double textHeight) =>
    textHeight +
    kLargeTitleTopSpace +
    kLargeTitleBottomSpace +
    kLargeTitleToolbarHeight;

/// 한 줄짜리 제목(메인 · 목록 · 홈 탭)의 확장 높이. [style] 은 [largeTitleStyle] 결과.
double largeTitleSingleLineExpandedHeight(TextStyle style) =>
    largeTitleExpandedHeight(largeTitleLineHeight(style));

/// 상세 제목이 늘어날 수 있는 최대 줄 수.
const int kDetailTitleMaxLines = 3;

/// 툴바 크럼브(상위 경로) 규칙.
///
/// 큰 제목은 "지금 보고 있는 것"만 말한다. 그 위 어디에서 왔는지(사이트 ·
/// 게시판)는 이미 있는 툴바 줄에 작게 적는다. 확장 영역 높이를 한 픽셀도
/// 더 쓰지 않으면서 목록 · 상세가 같은 리듬을 갖게 하려는 것.
///
/// - 메인(홈 탭: 게시판 · 지금 이슈 · 설정): 크럼브 없음 (최상위).
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
