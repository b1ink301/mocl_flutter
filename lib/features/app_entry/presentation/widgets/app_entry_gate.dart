import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/config/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/features/app_entry/data/shared_text_channel.dart';
import 'package:mocl_flutter/features/app_entry/domain/app_shortcut.dart';
import 'package:mocl_flutter/features/app_entry/domain/shared_text.dart';
import 'package:mocl_flutter/features/detail_page/domain/site_link_resolver.dart';
import 'package:mocl_flutter/features/issue_radar/presentation/state/issue_radar_state_mixin.dart';
import 'package:mocl_flutter/features/library/domain/library_segment.dart';
import 'package:mocl_flutter/features/library/presentation/state/library_event_mixin.dart';
import 'package:mocl_flutter/features/main_page/presentation/mocl_main_page.dart'
    show MainTab;
import 'package:mocl_flutter/features/main_page/presentation/state/main_event_mixin.dart';
import 'package:mocl_shared/util/mocl_logger.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:url_launcher/url_launcher.dart';

/// 앱 밖에서 들어오는 길. `MaterialApp.router` 의 builder 에서 감싼다.
///
/// - **공유로 받은 링크**(Android): 다른 앱에서 글 링크를 "공유 → Mocl" 하면 그 글
///   상세를 연다. 지원하지 않는 주소는 스낵바로 알리고 브라우저로 열 수 있게 한다.
/// - **앱 바로가기**(Android · iOS): 앱 아이콘을 길게 눌러 지금 이슈 · 스크랩 ·
///   최근 본 글 탭으로 바로 간다.
class const AppEntryGate({
  super.key,
  required final GoRouter router,
  required final Widget child,
}) extends HookConsumerWidget with MainEvent, LibraryEvent, IssueRadarState {
  static bool get _supportsShortcuts =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool issues = issueRadarAvailableState(ref);

    // 공유 받기.
    useEffect(() {
      if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
        return null;
      }
      final SharedTextChannel channel = SharedTextChannel()..listen();
      final StreamSubscription<String> sub = channel.onShared.listen((text) {
        if (context.mounted) _openShared(context, text);
      });
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final String? initial = await channel.takeInitial();
        if (initial != null && context.mounted) _openShared(context, initial);
      });
      return () {
        unawaited(sub.cancel());
        channel.dispose();
      };
    }, const []);

    // 앱 바로가기.
    useEffect(() {
      if (!_supportsShortcuts) return null;
      const QuickActions actions = QuickActions();
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        try {
          // 앱을 켠 바로가기도 initialize 의 콜백으로 온다.
          await actions.initialize((type) => _openShortcut(ref, type));
          await actions.setShortcutItems(<ShortcutItem>[
            for (final AppShortcut s in AppShortcut.visible(issues: issues))
              ShortcutItem(type: s.type, localizedTitle: s.title, icon: s.icon),
          ]);
        } catch (e, st) {
          MoclLogger.e('앱 바로가기 등록 실패', error: e, stackTrace: st);
        }
      });
      return null;
    }, [issues]);

    return child;
  }

  void _openShortcut(WidgetRef ref, String type) {
    final AppShortcut? shortcut = AppShortcut.fromType(type);
    if (shortcut == null) return;
    // 상세 · 목록 등 위에 쌓인 화면을 걷고 홈으로 간다.
    router.go(Routes.main);
    switch (shortcut) {
      case AppShortcut.issues:
        selectMainTab(ref, MainTab.issues);
      case AppShortcut.bookmarks:
        if (selectMainTab(ref, MainTab.bookmarks)) {
          unawaited(selectLibrarySegment(ref, LibrarySegment.bookmarks));
        }
      case AppShortcut.history:
        if (selectMainTab(ref, MainTab.bookmarks)) {
          unawaited(selectLibrarySegment(ref, LibrarySegment.history));
        }
    }
  }

  void _openShared(BuildContext context, String text) {
    final String? url = SharedText.firstUrl(text);
    if (url == null) {
      _snack(context, '공유한 내용에 링크가 없어요.');
      return;
    }
    final SiteLink? link = SiteLinkResolver.resolve(url);
    if (link != null) {
      unawaited(router.push(Routes.detail, extra: link));
      return;
    }
    _snack(
      context,
      'Mocl 에서 열 수 없는 링크예요.',
      action: SnackBarAction(
        label: '브라우저',
        onPressed: () => unawaited(
          launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
        ),
      ),
    );
  }

  void _snack(BuildContext context, String message, {SnackBarAction? action}) {
    final ScaffoldMessengerState? messenger = ScaffoldMessenger.maybeOf(
      context,
    );
    if (messenger == null) return;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 96),
          action: action,
        ),
      );
  }
}
