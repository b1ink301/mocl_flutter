import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/config/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/favorite/presentation/state/favorite_event_mixin.dart';
import 'package:mocl_flutter/features/favorite/presentation/state/favorite_state_mixin.dart';

import '../../../core/presentation/widgets/plain_text.dart';

/// 즐겨찾기한 게시판 목록 화면. 드로어 헤더의 별 버튼으로 진입한다.
/// 탭하면 사이트 전환 후 해당 게시판으로 이동하고, 왼쪽으로 밀면 해제된다.
class const FavoritesPage({super.key})
    extends ConsumerWidget
    with FavoriteState, FavoriteEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = favoritesState(ref);
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
              title: PlainText('즐겨찾기', style: titleStyle),
              backgroundColor: appBarTheme.backgroundColor,
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
                    child: Text(
                      '즐겨찾기한 게시판이 없습니다.\n게시판 목록에서 별을 눌러 추가하세요.',
                      textAlign: TextAlign.center,
                      style: styles.smallTextStyle,
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final f = items[i];
                    return Dismissible(
                      key: ValueKey('${f.siteType.name}_${f.board}'),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) =>
                          removeFavorite(ref, f.siteType, f.board),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.star_rounded,
                          color: theme.primaryColor,
                        ),
                        title: Text(
                          f.text,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: styles.titleTextStyle,
                        ),
                        subtitle: Text(
                          f.siteType.title,
                          style: styles.smallTextStyle,
                        ),
                        onTap: () {
                          // 리스트/파서는 전역 currentSiteType 을 따르므로,
                          // 다른 사이트 게시판이라도 먼저 사이트를 전환한 뒤 진입한다.
                          ref
                              .read(currentSiteTypeProvider.notifier)
                              .changeSiteType(f.siteType);
                          context.push(Routes.list, extra: f.toMainItem());
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
