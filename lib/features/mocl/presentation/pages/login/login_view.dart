import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    const headers = {
      'Referer':
          'https://nid.naver.com/mobile/user/help/naverProfile.nhn?lang=ko_KR',
      'ContentType': 'application/x-www-form-urlencoded'
    };

    // final uri = Uri.parse('https://nid.naver.com/nidlogin.login');
    // final WebViewController controller = WebViewController()
    //   ..setJavaScriptMode(JavaScriptMode.unrestricted)
    //   ..loadRequest(uri, headers: headers);
    //
    // return WebViewWidget(controller: controller);

    CookieManager cookieManager = CookieManager.instance();
    final uri = WebUri('https://naver.com');

    return InAppWebView(
      initialSettings: InAppWebViewSettings(
        incognito: false,
        isInspectable: kDebugMode,
        sharedCookiesEnabled: true,
        clearCache: false,
        cacheEnabled: true,
        disableContextMenu: false,
        javaScriptEnabled: true,
        useHybridComposition: true,
        thirdPartyCookiesEnabled: true,
        mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
      ),
      initialUrlRequest: URLRequest(
        url: WebUri(
            "https://nid.naver.com/mobile/user/help/naverProfile.nhn?lang=ko_KR"),
        headers: headers,
        httpShouldHandleCookies: true,
      ),
      onReceivedServerTrustAuthRequest: (controller, challenge) async =>
          ServerTrustAuthResponse(
              action: ServerTrustAuthResponseAction.PROCEED),
      onLoadStop: (controller, url) async {
        final cookies = await cookieManager.getCookies(url: uri);
        for (final cookie in cookies) {
          log('[onLoadStop] cookie=$cookie');

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
        }

        debugPrint('url?.path=${url?.path}');

        if (url?.path == '/user2/help/myInfoV2') {
          if (context.mounted) {
            GoRouter.of(context).pop(true);
          }
        }
      },
    );
  }
}
