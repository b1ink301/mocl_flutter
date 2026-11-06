import 'package:mocl_shared/remote_config/ads_config.dart';

/// 목록에서 광고를 넣을 자리. 값은 원격 설정(`ads.list`)에서 온다.
///
/// 첫 광고는 [first] 번째 글 뒤에, 그다음부터는 [interval] 개마다 넣는다.
class const ListAdPlacement({
  final int first = AdsRemoteConfig.defaultListFirst,
  final int interval = AdsRemoteConfig.defaultListInterval,
}) {
  /// [separatorIndex] 번째 구분선(= 글 `separatorIndex` 와 그다음 글 사이)에
  /// 광고가 들어가면 그 광고의 순번(0부터), 아니면 null.
  int? slotAt(int separatorIndex) {
    assert(first > 0 && interval > 0, 'first · interval 은 1 이상이어야 한다');
    final int after = separatorIndex + 1 - first;
    if (after < 0 || after % interval != 0) return null;
    return after ~/ interval;
  }
}
