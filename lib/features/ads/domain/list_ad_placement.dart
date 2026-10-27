/// 목록에서 광고를 넣을 자리.
///
/// 첫 광고는 [first] 번째 글 뒤에, 그다음부터는 [interval] 개마다 넣는다.
abstract final class ListAdPlacement() {
  static const int first = 5;
  static const int interval = 15;

  /// [separatorIndex] 번째 구분선(= 글 `separatorIndex` 와 그다음 글 사이)에
  /// 광고가 들어가면 그 광고의 순번(0부터), 아니면 null.
  static int? slotAt(int separatorIndex) {
    final int after = separatorIndex + 1 - first;
    if (after < 0 || after % interval != 0) return null;
    return after ~/ interval;
  }
}
