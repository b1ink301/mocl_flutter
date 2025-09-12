import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/di/app_provider.dart';
import 'package:mocl_flutter/features/app_shell/presentation/pages/login/providers/login_providers.dart';

const String _googleLoginUserAgent =
    'Mozilla/5.0 (Linux; Android 9; SM-G950N) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/88.0.4324.93 Mobile Safari/537.36';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final siteType = ref.watch(currentSiteTypeProvider);
    return InAppWebView(
      initialSettings: InAppWebViewSettings(
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
      ),
      initialUrlRequest: ref.watch(urlRequestProvider),
      onCreateWindow: (controller, createWindowAction) async {
        debugPrint('onCreateWindow ${createWindowAction.request.url}');

        if (createWindowAction.request.url.toString().contains(
          "login/google",
        )) {
          showDialog(
            context: context,
            builder: (context) => InAppWebView(
              initialUrlRequest: createWindowAction.request,
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                thirdPartyCookiesEnabled: true,
                mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
              ),
            ),
          );
        }
        return true;
      },
      onReceivedServerTrustAuthRequest: (controller, challenge) async =>
          ServerTrustAuthResponse(
            action: ServerTrustAuthResponseAction.PROCEED,
          ),
      onUpdateVisitedHistory:
          (
            InAppWebViewController controller,
            WebUri? url,
            bool? isReload,
          ) async {
            if (url == null) {
              return;
            }
            final bool isLogin = await _isLogin(url, siteType);
            debugPrint('[onUpdateVisitedHistory] isLogin=$isLogin, uri=$url');
            if (isLogin && context.mounted) {
              context.pop(true);
            }
          },
      onLoadStop: (InAppWebViewController controller, WebUri? url) async {
        if (url == null) {
          return;
        }
        final bool isLogin = await _isLogin(url, siteType);
        debugPrint('[onLoadStop] isLogin=$isLogin, uri=$url');
        if (isLogin && context.mounted) {
          context.pop(true);
        }
      },
    );
  }

  Future<bool> _isLogin(WebUri url, SiteType siteType) async {
    CookieManager cookieManager = CookieManager.instance();

    final List<Cookie> cookies = await cookieManager.getCookies(url: url);
    log('[hasLogin]#2 url=$url');
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
      log('[hasLogin] cookie=$cookie, uri=$url');
    }
    log('[hasLogin] siteType=$siteType, url.path=${url.path}');

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
