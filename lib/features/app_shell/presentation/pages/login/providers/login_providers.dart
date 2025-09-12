import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/di/app_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_providers.g.dart';

@riverpod
URLRequest urlRequest(Ref ref) {
  final siteType = ref.watch(currentSiteTypeProvider);
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

  final String url = switch (ref.watch(currentSiteTypeProvider)) {
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

// https://www.reddit.com/submit?type=TEXT
