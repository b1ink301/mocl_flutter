import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/login/providers/login_providers.dart';

const String _googleLoginUserAgent =
    'Mozilla/5.0 (Linux; Android 9; SM-G950N) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/88.0.4324.93 Mobile Safari/537.36';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CookieManager cookieManager = CookieManager.instance();

    return InAppWebView(
      initialSettings: InAppWebViewSettings(
        incognito: false,
        isInspectable: kDebugMode,
        sharedCookiesEnabled: true,
        safeBrowsingEnabled: false,
        clearCache: false,
        cacheEnabled: true,
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

        if (createWindowAction.request.url
            .toString()
            .contains("login/google")) {
          showDialog(
            context: context,
            builder: (context) {
              return InAppWebView(
                initialUrlRequest: createWindowAction.request,
                initialSettings: InAppWebViewSettings(
                  javaScriptEnabled: true,
                  thirdPartyCookiesEnabled: true,
                  mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
                ),
              );
            },
          );
        }
        return true;
      },
      onReceivedServerTrustAuthRequest: (
        InAppWebViewController controller,
        URLAuthenticationChallenge challenge,
      ) async =>
          ServerTrustAuthResponse(
              action: ServerTrustAuthResponseAction.PROCEED),
      onLoadStop: (
        InAppWebViewController controller,
        WebUri? url,
      ) async {
        if (url == null) {
          return;
        }

        final bool hasLogin =
            await ref.read(hasLoginProvider(cookieManager, url).future);

        debugPrint('hasLogin=$hasLogin, uri=$url');

        if (hasLogin && context.mounted) {
          context.pop(true);
        }
      },
    );
  }
}
