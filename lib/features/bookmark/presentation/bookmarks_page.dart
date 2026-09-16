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
              titleSpacing: 0,
              toolbarHeight: 62,
            ),
            body: async.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text('불러오기 실패: $e', style: styles.smallTextStyle),
              ),
              data: (items) {
                if (items.isEmpty) {
                  return Center(
                    child: Text('스크랩한 글이 없습니다.', style: styles.smallTextStyle),
                  );
                }
                return ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final b = items[i];
                    return Dismissible(
                      key: ValueKey('${b.siteType.name}_${b.id}'),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) => removeBookmark(ref, b.siteType, b.id),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: ListTile(
                        title: Text(
                          b.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: styles.titleTextStyle,
                        ),
                        subtitle: Text(
                          '${b.siteType.title} · ${b.boardTitle}',
                          style: styles.smallTextStyle,
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
