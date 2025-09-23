import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:flutter/foundation.dart';

const String _googleLoginUserAgent =
    'Mozilla/5.0 (Linux; Android 9; SM-G950N) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/88.0.4324.93 Mobile Safari/537.36';

mixin class LoginEvent {
  URLRequest urlRequest(WidgetRef ref, SiteType siteType) {
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
      SiteType.clien => 'https://m.clien.net/service/mypage/myInfo',
      SiteType.damoang => 'https://damoang.net/bbs/login.php?url=/bbs/memo.php',
      SiteType.meeco =>
        'https://meeco.kr/index.php?mid=index&act=dispMemberLoginForm',
      SiteType.naverCafe =>
        'https://nid.naver.com/mobile/user/help/naverProfile.nhn?lang=ko_KR',
      SiteType.reddit =>
        'https://www.reddit.com/login?dest=https://www.reddit.com/settings/',
      _ => '',
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
    clearCache: false,
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

  Future<bool> isLogin(WebUri url, SiteType siteType) async {
    CookieManager cookieManager = CookieManager.instance();

    final List<Cookie> cookies = await cookieManager.getCookies(url: url);
    for (final Cookie cookie in cookies) {
      await cookieManager.setCookie(
        url: url,
        name: cookie.name,
        value: cookie.value,
        domain: cookie.domain,
        path: cookie.path ?? '/',
        expiresDate: cookie.expiresDate,
        isSecure: cookie.isSecure,
        isHttpOnly: cookie.isHttpOnly,
        sameSite: cookie.sameSite,
      );
    }
    return switch (siteType) {
      SiteType.clien => url.path == '/service/mypage/myInfo',
      SiteType.damoang => url.path == '/bbs/memo.php',
      SiteType.meeco => url.path == '/',
      SiteType.naverCafe => url.path == '/user2/help/myInfoV2',
      SiteType.reddit => url.path == '/settings/',
      _ => throw UnimplementedError(),
    };
  }
}
