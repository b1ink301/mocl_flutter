import 'dart:developer';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/app_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_providers.g.dart';

@riverpod
URLRequest urlRequest(Ref ref) {
  final siteType = ref.watch(currentSiteTypeNotifierProvider);
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
    _ => const {}
  };

  final String url = switch (ref.watch(currentSiteTypeNotifierProvider)) {
    SiteType.clien => 'https://m.clien.net/service/mypage/myInfo',
    SiteType.damoang => 'https://damoang.net/bbs/login.php?url=/bbs/memo.php',
    SiteType.meeco =>
      'https://meeco.kr/index.php?mid=index&act=dispMemberLoginForm',
    SiteType.naverCafe =>
      'https://nid.naver.com/mobile/user/help/naverProfile.nhn?lang=ko_KR',
    SiteType.reddit =>
      'https://www.reddit.com/login?dest=https://www.reddit.com/settings/',
    _ => ''
  };

  return URLRequest(
    url: WebUri(url),
    headers: headers,
    httpShouldHandleCookies: true,
  );
}

@riverpod
Future<bool> hasLogin(Ref ref, CookieManager cookieManager, WebUri uri) async {
  final List<Cookie> cookies = await cookieManager.getCookies(url: uri);

  for (final Cookie cookie in cookies) {
    await cookieManager.setCookie(
      url: uri,
      name: cookie.name,
      value: cookie.value,
      domain: cookie.domain,
      path: cookie.path ?? '/',
      expiresDate: cookie.expiresDate,
      isSecure: cookie.isSecure,
      isHttpOnly: cookie.isHttpOnly,
      sameSite: cookie.sameSite,
    );
    log('[hasLogin] cookie=$cookie, uri=$uri');
  }

  final SiteType siteType = ref.watch(currentSiteTypeNotifierProvider);
  return switch (siteType) {
    SiteType.clien => uri.path == '/service/mypage/myInfo',
    SiteType.damoang => uri.path == '/bbs/memo.php',
    SiteType.meeco => uri.path == '/',
    SiteType.naverCafe => uri.path == '/user2/help/myInfoV2',
    SiteType.reddit => uri.path == '/settings/',
    _ => throw UnimplementedError()
  };
}

// https://www.reddit.com/submit?type=TEXT
