import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/config/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/bookmark/presentation/state/bookmark_event_mixin.dart';
import 'package:mocl_flutter/features/bookmark/presentation/state/bookmark_state_mixin.dart';

import '../../../core/presentation/widgets/plain_text.dart';
import '../../../core/presentation/widgets/site_avatar.dart';

class const BookmarksPage({super.key})
    extends ConsumerWidget
    with BookmarkState, BookmarkEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = bookmarksState(ref);
    final theme = Theme.of(context);
    final systemOverlayStyle =
        theme.appBarTheme.systemOverlayStyle ?? SystemUiOverlayStyle.light;
    final styles = ref.watch(appTextStylesFontSizeProvider);
    final titleStyle = ref.watch(appbarTextStyleProvider);
    final appBarTheme = theme.appBarTheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemOverlayStyle,
      child: Container(
        color: systemOverlayStyle.statusBarColor,
        child: SafeArea(
          bottom: false,
          child: Scaffold(
            appBar: AppBar(
              title: PlainText('스크랩', style: titleStyle),
              backgroundColor: appBarTheme.backgroundColor,
              // automaticallyImplyLeading: Platform.isMacOS,
              scrolledUnderElevation: 0,
              // titleSpacing: 0,
              toolbarHeight: kToolbarHeight,
              centerTitle: true,
            ),
            body: async.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text('불러오기 실패: $e', style: styles.smallTextStyle),
              ),
              data: (items) {
                if (items.isEmpty) {
                  return _EmptyView(style: styles.smallTextStyle);
                }
                // 마지막 줄이 떠 있는 탭바에 가리지 않도록 아래 여백을 준다
                // (홈 Scaffold 가 extendBody 라 padding.bottom 에 바 높이가 들어 있다).
                final double bottom = MediaQuery.of(context).padding.bottom;
                return ListView.separated(
                  padding: EdgeInsets.only(bottom: bottom + 8),
                  itemCount: items.length,
                  separatorBuilder: (_, _) =>
                      const Divider(height: 1, indent: 72),
                  itemBuilder: (context, i) {
                    final b = items[i];
                    return Dismissible(
                      key: ValueKey('${b.siteType.name}_${b.id}'),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) {
                        removeBookmark(ref, b.siteType, b.id);
                        final messenger = ScaffoldMessenger.of(context);
                        messenger.hideCurrentSnackBar();
                        messenger.showSnackBar(
                          SnackBar(
                            content: const Text('스크랩을 삭제했습니다.'),
                            behavior: SnackBarBehavior.floating,
                            // 하단 탭바 위로 띄운다.
                            margin: EdgeInsets.fromLTRB(16, 0, 16, bottom + 12),
                            action: SnackBarAction(
                              label: '실행취소',
                              onPressed: () => addBookmark(ref, b),
                            ),
                          ),
                        );
                      },
                      background: _DismissBackground(theme: theme),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        leading: SiteAvatar(siteType: b.siteType, radius: 18),
                        title: Text(
                          b.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: styles.titleTextStyle,
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            '${b.siteType.title} · ${b.boardTitle}'
                            ' · ${_savedAgo(b.savedAt)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: styles.smallTextStyle,
                          ),
                        ),
                        onTap: () {
                          // 상세는 현재 사이트 기준으로 동작하므로 먼저 사이트를 전환한다.
                          ref
                              .read(currentSiteTypeProvider.notifier)
                              .changeSiteType(b.siteType);
                          context.push(Routes.detail, extra: b.toListItem());
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// 스크랩을 담은 시각을 '방금 · N분 전 · N시간 전 · N일 전' 으로 줄여 준다.
/// 한 달이 넘으면 상대 표기가 감이 안 오므로 날짜(YY.MM.DD)로 바꾼다.
String _savedAgo(int savedAt) {
  if (savedAt <= 0) return '';
  final DateTime saved = DateTime.fromMillisecondsSinceEpoch(savedAt);
  final Duration diff = DateTime.now().difference(saved);
  if (diff.inMinutes < 1) return '방금';
  if (diff.inHours < 1) return '${diff.inMinutes}분 전';
  if (diff.inDays < 1) return '${diff.inHours}시간 전';
  if (diff.inDays < 30) return '${diff.inDays}일 전';
  final String yy = (saved.year % 100).toString().padLeft(2, '0');
  final String mm = saved.month.toString().padLeft(2, '0');
  final String dd = saved.day.toString().padLeft(2, '0');
  return '$yy.$mm.$dd';
}

/// 스와이프 삭제 배경. 원색 빨강 대신 테마 오류색을 옅게 깔고, 아이콘과 함께
/// 무슨 동작인지 글자로도 알려 준다.
class const _DismissBackground({required final ThemeData theme})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Color color = theme.colorScheme.error;
    return Container(
      color: color.withValues(alpha: 0.12),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 24),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.delete_outline, color: color, size: 22),
          const SizedBox(width: 6),
          Text(
            '삭제',
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

/// 스크랩이 하나도 없을 때의 안내.
class const _EmptyView({required final TextStyle style})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color muted = theme.hintColor;
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 0, 32, 72),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.bookmark_border,
              size: 44,
              color: muted.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 12),
            Text('스크랩한 글이 없습니다.', style: style.copyWith(color: muted)),
            const SizedBox(height: 6),
            Text(
              '글 상세 화면의 북마크 버튼으로 담아 두세요.',
              textAlign: TextAlign.center,
              style: style.copyWith(color: muted.withValues(alpha: 0.8)),
            ),
          ],
        ),
      ),
    );
  }
}
