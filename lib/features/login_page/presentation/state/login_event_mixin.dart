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
      // 로그인 뒤 이동하는 주소가 자주 바뀌어(/settings/ → /settings/account 등)
      // 주소 대신 로그인 세션 쿠키로 판정한다. 이미 로그인돼 있으면 바로 닫힌다.
      // 로그인 페이지에 머무는 동안은 보지 않는다 — 만료된 쿠키가 남아 있으면
      // 화면이 곧바로 닫혀 다시 로그인할 수 없다(유효하면 레딧이 dest 로 넘긴다).
      SiteType.reddit =>
        url.host.endsWith('reddit.com') &&
            !url.path.startsWith('/login') &&
            cookies.any(
              (c) => c.name == 'reddit_session' && '${c.value}'.isNotEmpty,
            ),
      _ => false,
    };
  }
}
