import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/remote_config/application/remote_config_providers.dart';
import 'package:mocl_shared/remote_config/ads_config.dart';

import '../../domain/list_ad_placement.dart';

/// 광고 자리 · 크기. 원격 설정(`ads`)을 따르고, 없으면 앱 기본값.
/// 원격 설정은 실행 중에 바뀌지 않으므로 광고를 다시 받는 일도 없다.
mixin class AdsState() {
  /// 글 상세 광고 크기.
  DetailAdSize detailAdSizeState(WidgetRef ref) =>
      ref.watch(remoteConfigProvider.select((c) => c.ads.effectiveDetail));

  /// 목록에서 광고를 넣을 자리.
  ListAdPlacement listAdPlacementState(WidgetRef ref) {
    final (int first, int interval) = ref.watch(
      remoteConfigProvider.select(
        (c) => (c.ads.effectiveListFirst, c.ads.effectiveListInterval),
      ),
    );
    return ListAdPlacement(first: first, interval: interval);
  }
}
