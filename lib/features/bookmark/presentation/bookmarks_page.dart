import 'package:mocl_flutter/core/presentation/widgets/window_size.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/config/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/presentation/widgets/list_detail_layout.dart';
import 'package:mocl_flutter/features/database/domain/entities/post_snapshot.dart';
import 'package:mocl_flutter/features/detail_page/presentation/mocl_detail_page.dart';
import 'package:mocl_flutter/features/bookmark/presentation/state/bookmark_event_mixin.dart';
import 'package:mocl_flutter/features/bookmark/presentation/state/bookmark_state_mixin.dart';

import '../../../core/presentation/widgets/failure_view.dart';
import '../../../core/presentation/widgets/large_title_sliver_app_bar.dart';

/// 스크랩 목록. 홈 "보관함" 탭의 한 칸이다(`LibraryPage`).
class const BookmarksPage({
  super.key,
  final String title = '스크랩',

  /// 큰 제목 아래에 둘 위젯(보관함의 칸 전환).
  final Widget? header,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      // 넓은 화면(태블릿 가로 · 펼친 폴드 · iPad)에서는 목록 옆에 상세를 둔다.
      ListDetailLayout<PostSnapshot>(
        list: _BookmarksScaffold(title: title, header: header),
        detailBuilder: (_, b) =>
            DetailPage.init(b.toListItem(), siteType: b.siteType),
        pushDetail: (context, b) =>
            context.push<void>(Routes.detail, extra: b.toListItem()),
        keyOf: _bookmarkKey,
        detailRoutePath: Routes.detail,
      );
}

String _bookmarkKey(PostSnapshot b) => '${b.siteType.name}_${b.id}';

/// 게시판 탭과 같은 큰 제목 앱바 + 스크랩 목록.
class const _BookmarksScaffold({
  required final String title,
  required final Widget? header,
}) extends ConsumerWidget with BookmarkState, BookmarkEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = bookmarksState(ref);
    final styles = ref.watch(appTextStylesFontSizeProvider);
    // 떠 있는 탭바에 가리지 않게(홈 Scaffold 가 바 높이를 더해 준다).
    final double bottom = MediaQuery.paddingOf(context).bottom;

    return CustomScrollView(
      slivers: <Widget>[
        LargeTitleSliverAppBar(title: title),
        if (header case final Widget header) SliverToBoxAdapter(child: header),
        async.when(
          loading: () => const SliverMessageView(
            child: CircularProgressIndicator.adaptive(),
          ),
          error: (e, _) => SliverMessageView(
            child: FailureView(
              error: e,
              titleStyle: styles.titleTextStyle,
              descriptionStyle: styles.smallTextStyle,
            ),
          ),
          data: (items) {
            if (items.isEmpty) {
              return SliverMessageView(
                child: MessageView(
                  icon: Icons.bookmark_border,
                  title: '스크랩한 글이 없어요',
                  description: '글 화면 위쪽의 스크랩 버튼을 누르면 여기에 모아 둬요.',
                  titleStyle: styles.titleTextStyle,
                  descriptionStyle: styles.smallTextStyle,
                ),
              );
            }
            // 넓은 화면에서는 목록을 읽기 좋은 폭으로 가운데 모은다.
            return SliverReadableWidth(
              sliver: SliverPadding(
                padding: EdgeInsets.only(bottom: bottom + 16),
                sliver: SliverList.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final b = items[i];
                    return Dismissible(
                      key: ValueKey(_bookmarkKey(b)),
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
                        selected: ListDetailScope.isSelected(
                          context,
                          _bookmarkKey(b),
                        ),
                        onTap: () {
                          // 상세는 현재 사이트 기준으로 동작하므로 먼저 사이트를 전환한다.
                          ref
                              .read(currentSiteTypeProvider.notifier)
                              .changeSiteType(b.siteType);
                          if (ListDetailScope.tryOpen(context, b)) return;
                          context.push(Routes.detail, extra: b.toListItem());
                        },
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
