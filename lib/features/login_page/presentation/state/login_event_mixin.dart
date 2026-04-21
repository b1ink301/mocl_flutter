import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';

mixin class LoginEvent {
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
