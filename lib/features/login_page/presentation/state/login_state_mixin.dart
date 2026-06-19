import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';

// 로그인 웹뷰 UA. 구글 로그인은 웹뷰(`; wv`)/구버전 브라우저를 "안전하지 않은
// 브라우저"로 차단하므로, 웹뷰 토큰 없는 최신 모바일 Chrome UA 를 사용한다.
const String _googleLoginUserAgent =
    'Mozilla/5.0 (Linux; Android 16; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36';

mixin class LoginState {
  SiteType siteTypeState(WidgetRef ref) => ref.watch(currentSiteTypeProvider);

  URLRequest urlRequest(SiteType siteType) {
    final Map<String, String> headers = switch (siteType) {
      SiteType.clien => {
        'Referer': 'https://m.clien.net/service/mypage/myInfo',
        'ContentType': 'application/x-www-form-urlencoded',
      },
      SiteType.damoang => {
        'Referer': 'https://damoang.net/bbs/memo.php',
        'ContentType': 'application/x-www-form-urlencoded',
      },
      SiteType.reddit => <String, String>{
        'Referer': 'https://www.reddit.com/settings/',
        'ContentType': 'application/x-www-form-urlencoded',
      },
      SiteType.meeco => <String, String>{},
      SiteType.naverCafe => {
        'Referer':
            'https://nid.naver.com/mobile/user/help/naverProfile.nhn?lang=ko_KR',
        'ContentType': 'application/x-www-form-urlencoded',
      },
      _ => const {},
    };

    final String url = switch (siteType) {
      SiteType.arcalive => 'https://arca.live/u/login',
      SiteType.bobaedream => 'https://m.bobaedream.co.kr/member/login',
      SiteType.clien => 'https://m.clien.net/service/mypage/myInfo',
      // 82쿡 로그인 UI 는 JS 로 렌더되어 전용 URL 이 불안정 → 홈에서 헤더
      // 로그인 후 '완료' 로 확정한다.
      SiteType.cook82 => 'https://www.82cook.com/',
      SiteType.damoang => 'https://damoang.net/bbs/login.php?url=/bbs/memo.php',
      SiteType.dcinside => 'https://m.dcinside.com/auth/login',
      SiteType.dogdrip => 'https://www.dogdrip.net/login',
      SiteType.instiz => 'https://www.instiz.net/login',
      SiteType.inven => 'https://member.inven.co.kr/user/scorpio/mlogin',
      SiteType.meeco =>
        'https://meeco.kr/index.php?mid=index&act=dispMemberLoginForm',
      SiteType.mlbpark => 'https://mlbpark.donga.com/mp/login.php',
      SiteType.naverCafe =>
        'https://nid.naver.com/mobile/user/help/naverProfile.nhn?lang=ko_KR',
      SiteType.ppomppu => 'https://m.ppomppu.co.kr/new/login.php',
      SiteType.reddit =>
        'https://www.reddit.com/login?dest=https://www.reddit.com/settings/',
      SiteType.ruliweb => 'https://m.ruliweb.com/member/login',
      SiteType.theqoo =>
        'https://theqoo.net/index.php?mid=hot&act=dispMemberLoginForm',
      SiteType.geekNews || SiteType.settings => '',
    };

    return URLRequest(
      url: WebUri(url),
      headers: headers,
      httpShouldHandleCookies: true,
    );
  }

  InAppWebViewSettings inAppWebViewSettings() => InAppWebViewSettings(
    incognito: false,
    isInspectable: kDebugMode,
    sharedCookiesEnabled: true,
    safeBrowsingEnabled: false,
    cacheEnabled: false,
    supportMultipleWindows: true,
    disableContextMenu: false,
    javaScriptEnabled: true,
    javaScriptCanOpenWindowsAutomatically: true,
    useHybridComposition: true,
    thirdPartyCookiesEnabled: true,
    mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
    userAgent: _googleLoginUserAgent,
  );
}
