import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/features/login_page/presentation/state/login_event_mixin.dart';
import 'package:mocl_flutter/features/login_page/presentation/state/login_state_mixin.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginView extends ConsumerWidget with LoginState, LoginEvent {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final siteType = siteTypeState(ref);
    return InAppWebView(
      initialSettings: inAppWebViewSettings(),
      initialUrlRequest: urlRequest(ref, siteType),
      shouldOverrideUrlLoading: (controller, navigationAction) async {
        final url = navigationAction.request.url;
        if (url == null) return NavigationActionPolicy.ALLOW;

        final scheme = url.scheme;
        // http/https는 웹뷰에서 정상 처리
        if (scheme == 'http' || scheme == 'https') {
          return NavigationActionPolicy.ALLOW;
        }

        // intent://, market://, 커스텀 스킴 등은 외부 앱으로 전달
        try {
          final uri = _resolveUri(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        } catch (_) {}
        return NavigationActionPolicy.CANCEL;
      },
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

  /// intent:// URI를 실제 앱 스킴 URI로 변환합니다.
  /// intent://path#Intent;scheme=app;package=com.example;end → app://path
  static Uri _resolveUri(WebUri url) {
    if (url.scheme == 'intent') {
      final fragment = url.fragment;
      final schemeMatch = RegExp(r'scheme=([^;]+)').firstMatch(fragment);
      if (schemeMatch != null) {
        final appScheme = schemeMatch.group(1)!;
        final path = url.toString().replaceFirst('intent:', '');
        final pathEnd = path.indexOf('#');
        final cleanPath = pathEnd > 0 ? path.substring(0, pathEnd) : path;
        return Uri.parse('$appScheme:$cleanPath');
      }
      // fallback: market 스토어로
      final packageMatch = RegExp(r'package=([^;]+)').firstMatch(fragment);
      if (packageMatch != null) {
        return Uri.parse('market://details?id=${packageMatch.group(1)}');
      }
    }
    return Uri.parse(url.toString());
  }
}
