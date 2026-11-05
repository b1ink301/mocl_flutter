import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_shared/remote_config/remote_config.dart';

// 차단 회피를 위해 최신 Chrome(2026.06 기준 150) UA 로 맞춘다. 웹뷰 식별
// 토큰(`; wv`)을 빼 일반 모바일 Chrome 으로 보이게 해 차단률을 낮춘다.
// 앱과 서버(크롤러)가 같은 값을 쓴다. 바꿀 땐 앱 업데이트 대신 원격 설정을 먼저 쓴다.
const String userAgentMobile =
    'Mozilla/5.0 (Linux; Android 16; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36';
const String userAgentPc =
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36';

/// 사이트 요청 UA 프리셋의 기본값. 원격 설정(`RemoteConfig.userAgents`)이
/// 있으면 그 값이 이긴다.
const Map<UserAgentPreset, String> builtInUserAgents = {
  UserAgentPreset.mobile: userAgentMobile,
  UserAgentPreset.pc: userAgentPc,
};

/// 사이트별 기본 프리셋. PC 마크업을 파싱하는 사이트만 pc 다.
UserAgentPreset defaultUserAgentPreset(SiteType site) => switch (site) {
  SiteType.clien || SiteType.damoang || SiteType.reddit => UserAgentPreset.pc,
  _ => UserAgentPreset.mobile,
};
