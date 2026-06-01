import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';

const String _googleLoginUserAgent =
    'Mozilla/5.0 (Linux; Android 9; SM-G950N) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/88.0.4324.93 Mobile Safari/537.36';

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
