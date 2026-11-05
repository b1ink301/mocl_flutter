import 'dart:async';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/config/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/features/detail_page/domain/site_link_resolver.dart';
import 'package:mocl_flutter/features/keyword_alerts/data/push_messaging.dart';
import 'package:url_launcher/url_launcher.dart';

import '../state/keyword_alert_event_mixin.dart';

/// 키워드 알림을 받는 쪽. `MaterialApp.router` 의 builder 에서 감싼다.
///
/// - 알림을 눌러 들어오면(꺼져 있었든 뒤에 있었든) 그 글 상세를 연다.
/// - 앱이 앞에 있을 때 온 알림은 시스템이 띄우지 않으므로 스낵바로 보여 준다.
/// - 실행할 때와 FCM 토큰이 바뀔 때 서버 등록을 다시 맞춘다.
class const KeywordAlertGate({
  super.key,
  required final GoRouter router,
  required final Widget child,
}) extends HookConsumerWidget with KeywordAlertEvent {
  /// 첫 화면 · 다른 시작 작업(업데이트 확인 등) 뒤에 한다.
  static const Duration _launchDelay = Duration(seconds: 2);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      if (!readKeywordAlertsAvailable(ref)) return null;
      final PushMessaging messaging = readPushMessaging(ref);
      final List<StreamSubscription<Object>> subs = [];
      Timer? timer;

      try {
        subs
          ..add(messaging.onTap.listen((tap) => _open(tap)))
          ..add(
            messaging.onForeground.listen((tap) {
              if (context.mounted) _showForeground(context, tap);
            }),
          )
          ..add(
            messaging.onTokenRefresh.listen((_) {
              if (readHasKeywordAlerts(ref)) unawaited(syncKeywordAlerts(ref));
            }),
          );
      } catch (_) {
        // Firebase 초기화에 실패한 빌드(main.dart 참고). 알림만 쓰지 못한다.
        return null;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        timer = Timer(_launchDelay, () async {
          try {
            final PushTap? initial = await messaging.initialTap();
            if (initial != null) _open(initial);
          } catch (_) {}
          if (readHasKeywordAlerts(ref)) unawaited(syncKeywordAlerts(ref));
        });
      });

      return () {
        timer?.cancel();
        for (final s in subs) {
          unawaited(s.cancel());
        }
      };
    }, const []);

    return child;
  }

  void _open(PushTap tap) {
    final String? url = tap.url;
    if (url == null || url.isEmpty) return;
    final SiteLink? link = SiteLinkResolver.resolve(url);
    if (link != null) {
      unawaited(router.push(Routes.detail, extra: link));
    } else {
      unawaited(
        launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
      );
    }
  }

  void _showForeground(BuildContext context, PushTap tap) {
    final ScaffoldMessengerState? messenger = ScaffoldMessenger.maybeOf(
      context,
    );
    final String? title = tap.title;
    if (messenger == null || title == null) return;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            '🔔 $title',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 96),
          duration: const Duration(seconds: 6),
          action: SnackBarAction(label: '보기', onPressed: () => _open(tap)),
        ),
      );
  }
}
