import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mocl_flutter/core/util/mocl_logger.dart';

import '../domain/ad_unit_ids.dart';

/// 광고를 요청해도 되는 상태인지. 동의(UMP) 확인과 SDK 초기화가 끝나야 true.
/// 목록은 이 값이 true 가 된 뒤에만 광고를 불러온다.
final ValueNotifier<bool> mobileAdsReady = ValueNotifier<bool>(false);

bool _started = false;

/// 광고 동의 확인 → SDK 초기화. 첫 화면을 늦추지 않도록 첫 프레임 뒤에 돌린다.
/// 부팅 재시도로 여러 번 불려도 한 번만 돈다.
void scheduleMobileAdsInit() {
  if (!AdUnitIds.enabled || _started) return;
  _started = true;
  WidgetsBinding.instance.addPostFrameCallback((_) {
    unawaited(_init());
  });
}

Future<void> _init() async {
  try {
    // EEA · UK 등 동의가 필요한 지역이면 동의 화면을 띄운다. 필요 없는 지역이면
    // 화면 없이 바로 끝난다. 갱신이 실패해도 지난번 동의 상태로 판단한다.
    await _updateConsentInfo();
    await _showConsentFormIfRequired();

    if (!await ConsentInformation.instance.canRequestAds()) {
      MoclLogger.d(() => '[ads] 동의가 없어 광고를 요청하지 않는다');
      return;
    }

    final InitializationStatus status = await MobileAds.instance.initialize();
    MoclLogger.d(
      () =>
          '[ads] initialized: ${status.adapterStatuses.map((k, v) => MapEntry(k, v.state.name))}',
    );
    mobileAdsReady.value = true;
  } catch (e, st) {
    // 광고가 안 떠도 앱은 쓸 수 있다.
    MoclLogger.e('광고 SDK 초기화 실패', error: e, stackTrace: st);
  }
}

Future<void> _updateConsentInfo() {
  final Completer<void> done = Completer<void>();
  ConsentInformation.instance.requestConsentInfoUpdate(
    ConsentRequestParameters(),
    done.complete,
    (FormError error) {
      MoclLogger.w(() => '[ads] 동의 정보 갱신 실패: ${error.message}');
      done.complete();
    },
  );
  return done.future;
}

Future<void> _showConsentFormIfRequired() =>
    ConsentForm.loadAndShowConsentFormIfRequired((FormError? error) {
      if (error != null) {
        MoclLogger.w(() => '[ads] 동의 화면 실패: ${error.message}');
      }
    });
