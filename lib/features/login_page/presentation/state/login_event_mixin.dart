import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';

mixin class LoginEvent() {
  Future<bool> isLogin(WebUri url, SiteType siteType) async {
    CookieManager cookieManager = CookieManager.instance();

    final List<Cookie> cookies = await cookieManager.getCookies(url: url);
    for (final Cookie cookie in cookies) {
      await cookieManager.setCookie(
        url: url,
        name: cookie.name,
        value: cookie.value as String,
        domain: cookie.domain,
        path: cookie.path ?? '/',
        expiresDate: cookie.expiresDate,
        isSecure: cookie.isSecure,
        isHttpOnly: cookie.isHttpOnly,
        sameSite: cookie.sameSite,
      );
    }
    // 로그인 성공 후 도달하는 페이지(마이페이지 등) URL 로 자동 판정한다.
    // 사이트마다 로그인 후 리다이렉트가 제각각이라 자동 판정이 어려운 곳은
    // 로그인 화면의 '완료' 버튼으로 수동 확정한다(여기서는 false 반환).
    return switch (siteType) {
      SiteType.clien => url.path == '/service/mypage/myInfo',
      SiteType.damoang => url.path == '/bbs/memo.php',
      SiteType.meeco => url.path == '/',
      SiteType.naverCafe => url.path == '/user2/help/myInfoV2',
      SiteType.reddit => url.path == '/settings/',
      _ => false,
    };
  }
}
