import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/features/login_page/presentation/state/login_event_mixin.dart';
import 'package:mocl_flutter/features/login_page/presentation/state/login_state_mixin.dart';

class LoginView extends ConsumerWidget with LoginState, LoginEvent {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final siteType = siteTypeState(ref);
    return InAppWebView(
      initialSettings: inAppWebViewSettings(),
      initialUrlRequest: urlRequest(ref, siteType),
      onCreateWindow: (controller, createWindowAction) async {
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
            if (await isLogin(url, siteType) && context.mounted) {
              context.pop(true);
            }
          },
      onLoadStop: (InAppWebViewController controller, WebUri? url) async {
        if (url == null) {
          return;
        }
        if (await isLogin(url, siteType) && context.mounted) {
          context.pop(true);
        }
      },
    );
  }
}
