/// 글 목록 밀도(설정 "목록 밀도").
enum ListDensity() {
  /// 지금 모양: 제목 여러 줄 · 닉 이미지 · 정보 줄 아래 댓글 배지.
  standard,

  /// 제목 한 줄 + 댓글 배지를 제목 옆으로, 닉 이미지 없이 위아래 여백을 줄인다.
  /// 한 화면에 약 1.4배가 들어간다.
  compact,
}

/// 컴팩트 행의 위아래 여백 · 줄 사이.
typedef CompactSpacing = ({double padding, double gap});

/// 화면 세로 길이(dp)에 맞춘 컴팩트 여백.
///
/// 세로로 긴 화면(고해상도 · 큰 폰)은 한 화면에 행이 너무 많이 들어가 빽빽해 보여서, 화면이 길수록
/// 여백을 늘린다: 700dp 이하 9 · 3 → 900dp 이상 13 · 6(그 사이는 비례, 0.5 단위로 반올림).
/// 줄 사이는 기본 목록(8)보다는 좁게 둬 제목 · 정보가 한 덩어리로 보이게 한다.
/// 픽셀 밀도는 dp 로 이미 보정되므로 보지 않는다. 목록 광고도 같은 값을 쓴다.
CompactSpacing compactSpacingFor(double screenHeight) {
  final double t = ((screenHeight - 700) / 200).clamp(0.0, 1.0);
  double half(double v) => (v * 2).roundToDouble() / 2;
  return (padding: half(9 + 4 * t), gap: half(3 + 3 * t));
}
