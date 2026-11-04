import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/util/mocl_logger.dart';
import 'package:mocl_flutter/features/login_page/presentation/state/login_event_mixin.dart';
import 'package:mocl_flutter/features/login_page/presentation/state/login_state_mixin.dart';
import 'package:url_launcher/url_launcher.dart';

/// [siteType] 이 없으면 지금 고른 사이트에 로그인한다.
class const LoginView({super.key, final SiteType? siteType})
    extends ConsumerWidget
    with LoginState, LoginEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final siteType = this.siteType ?? siteTypeState(ref);
    return InAppWebView(
      initialSettings: inAppWebViewSettings(),
      initialUrlRequest: urlRequest(siteType),
      shouldOverrideUrlLoading: (controller, navigationAction) async {
        final url = navigationAction.request.url;
        if (url == null) return NavigationActionPolicy.ALLOW;

        final scheme = url.scheme;
        // http/https 와 페이지 안에서만 쓰는 스킴(about:blank, data:, blob: …)은
        // 웹뷰에서 처리한다. macOS 는 iframe(reCAPTCHA · 구글 로그인 등)의
        // about:blank 까지 여기로 보내서, 외부로 넘기면 "about:blank URL 을 열
        // 응용 프로그램이 없습니다" 창이 뜬다. 프레임으로 거르지 않는 건
        // naverlogin:// 같은 앱 로그인 스킴을 iframe 에서 부르는 사이트도 있어서다.
        if (scheme == 'http' ||
            scheme == 'https' ||
            _inPageSchemes.contains(scheme)) {
          return NavigationActionPolicy.ALLOW;
        }

        // intent://, market://, naverlogin:// 등 앱 스킴은 외부 앱으로 전달
        try {
          final uri = _resolveUri(url);

          MoclLogger.d(() => '[shouldOverrideUrlLoading] url=$url, uri=$uri');
          // macOS 는 받을 앱이 없는 스킴을 열면 Finder 의 "응용 프로그램 선택"
          // 창을 띄우므로 먼저 확인한다. Android 는 <queries> 없이는
          // canLaunchUrl 이 늘 false 라, iOS 는 Info.plist 에 등록한 스킴만
          // 확인할 수 있어 확인 없이 연다(앱이 없으면 조용히 실패한다).
          if (defaultTargetPlatform == TargetPlatform.macOS &&
              !await canLaunchUrl(uri)) {
            return NavigationActionPolicy.CANCEL;
          }
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } catch (_) {}
        return NavigationActionPolicy.CANCEL;
      },
      // 소셜 로그인(구글 · 애플 등)은 팝업 창으로 열리고, 결과를 window.opener 로
      // 원래 페이지에 돌려준다. windowId 로 열어야 그 연결이 유지된다(주소만 다시
      // 열면 결과가 돌아가지 않아 로그인이 끝나지 않는다). 팝업이 window.close()
      // 하면 대화상자도 닫는다.
      onCreateWindow: (controller, createWindowAction) async {
        showDialog<void>(
          context: context,
          builder: (dialogContext) => Dialog(
            clipBehavior: Clip.antiAlias,
            insetPadding: const EdgeInsets.all(16),
            child: InAppWebView(
              windowId: createWindowAction.windowId,
              initialSettings: inAppWebViewSettings(),
              onCloseWindow: (_) {
                if (dialogContext.mounted) Navigator.of(dialogContext).pop();
              },
            ),
          ),
        );
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
              _close(context);
            }
          },
      onLoadStop: (InAppWebViewController controller, WebUri? url) async {
        if (url == null) {
          return;
        }
        if (await isLogin(url, siteType) && context.mounted) {
          _close(context);
        }
      },
    );
  }

  /// 로그인 화면을 닫는다. onUpdateVisitedHistory 와 onLoadStop 이 연달아
  /// 판정에 성공하면 두 번 pop 되어 아래 화면(게시판 추가 시트)까지 닫히므로,
  /// 이 화면이 아직 맨 위일 때만 닫는다.
  static void _close(BuildContext context) {
    if (!context.mounted) return;
    if (ModalRoute.of(context)?.isCurrent == false) return;
    context.pop(true);
  }

  /// 외부 앱이 아니라 웹뷰 자신이 처리하는 스킴.
  static const Set<String> _inPageSchemes = {
    'about',
    'data',
    'blob',
    'javascript',
  };

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
