import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/providers/main_providers.dart';
import 'package:mocl_flutter/features/mocl/presentation/routes/mocl_routes.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/loading_widget.dart';

class MainView extends ConsumerStatefulWidget {
  const MainView({super.key});

  @override
  MainViewState createState() => MainViewState();
}

class MainViewState extends ConsumerState<MainView> {
  @override
  Widget build(BuildContext context) => SafeArea(
    left: false,
    right: false,
    child: RefreshIndicator.adaptive(
      color: Theme.of(context).focusColor,
      onRefresh: () async =>
          ref.read(mainItemsNotifierProvider.notifier).refresh(),
      child: CustomScrollView(
        slivers: <Widget>[
          PlatformWidget(
            material: (_, _) => const _MainAppBar(),
            cupertino: (_, _) => const _MainNavigationBar(),
          ),
          const _MainBody(),
        ],
      ),
    ),
  );
}

class _MainBody extends ConsumerWidget {
  const _MainBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(mainItemsNotifierProvider.select((value) => value), (
      AsyncValue? previous,
      AsyncValue? next,
    ) {
      if (next case AsyncError error when error.error is NotLoginFailure) {
        context.push<bool>(Routes.login).then((bool? result) {
          if (context.mounted && result == true) {
            ref.read(mainItemsNotifierProvider.notifier).refresh();
          }
        });
      }
    });

    return ref
        .watch(mainItemsNotifierProvider)
        .when(
          data: (List<MainItem> data) => _buildListView(context, data),
          error: (Object error, StackTrace stack) => _buildErrorView(
            context,
            error is Failure ? error.message : error.toString(),
          ),
          loading: () => _buildLoadingView(),
        );
  }

  Widget _buildLoadingView() => const SliverToBoxAdapter(
    child: Column(children: [LoadingWidget(), DividerWidget()]),
  );

  Widget _buildEmptyView(TextStyle? textStyle) => SliverFillRemaining(
    hasScrollBody: false,
    child: Center(
      child: PlatformText('항목이 없습니다.\n항목을 추가해 주세요!', style: textStyle),
    ),
  );

  Widget _buildListView(BuildContext context, List<MainItem> items) {
    final textStyle = MoclTextStyles.of(
      context,
    ).titleTextStyle.copyWith(fontSize: 16.8);
    return items.isEmpty
        ? _buildEmptyView(textStyle)
        : SliverList.separated(
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) =>
                _buildListItem(context, items[index], textStyle),
            separatorBuilder: (_, _) => const DividerWidget(),
          );
  }

  Widget _buildListItem(
    BuildContext context,
    MainItem item,
    TextStyle? textStyle,
  ) => PlatformListTile(
    key: ValueKey(item.board),
    leading: item.icon.isEmpty ? null : _buildIconView(item.icon),
    title: PlatformText(item.text, style: textStyle),
    onTap: () async {
      await context.push(Routes.list, extra: item);
    },
    material: (_, _) => MaterialListTileData(
      contentPadding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
    ),
    cupertino: (_, _) => CupertinoListTileData(
      padding: const EdgeInsets.fromLTRB(16, 18, 8, 18),
      additionalInfo: Icon(CupertinoIcons.chevron_forward),
    ),
  );

  Widget _buildErrorView(BuildContext context, String message) => SliverPadding(
    padding: const EdgeInsets.all(12.0),
    sliver: SliverToBoxAdapter(
      child: PlatformText(
        message,
        style: TextStyle(fontSize: 16, color: Theme.of(context).focusColor),
      ),
    ),
  );

  Widget _buildIconView(String url) => CircleAvatar(
    radius: 24,
    backgroundImage: CachedNetworkImageProvider(url),
  );
}

class _MainAppBar extends ConsumerWidget {
  const _MainAppBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) => SliverAppBar(
    scrolledUnderElevation: 0,
    title: PlatformText(ref.watch(mainTitleProvider)),
    titleTextStyle: Theme.of(context).textTheme.labelMedium,
    titleSpacing: 0,
    floating: true,
    centerTitle: false,
    toolbarHeight: 64,
    actions: !ref.watch(showAddButtonProvider)
        ? null
        : [
            PlatformIconButton(
              onPressed: () => ref.read(handleAddButtonProvider(context)),
              icon: const Icon(Icons.add),
            ),
            PlatformPopupMenu(
              options: [
                PopupMenuOption(
                  label: '로그인',
                  onTap: (_) =>
                      context.push<bool>(Routes.login).then((bool? result) {}),
                ),
              ],
              icon: Icon(
                size: 24,
                context.platformIcon(
                  material: Icons.more_vert_rounded,
                  cupertino: CupertinoIcons.ellipsis,
                ),
              ),
            ),
          ],
  );
}

class _MainNavigationBar extends ConsumerWidget {
  const _MainNavigationBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      CupertinoSliverNavigationBar(
        largeTitle: PlatformText(ref.watch(mainTitleProvider)),
        padding: const EdgeInsetsDirectional.only(start: 5, end: 10),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: PlatformIconButton(
          padding: const EdgeInsets.all(0),
          onPressed: () =>
              ref.read(mainSidebarNotifierProvider.notifier).toggle(),
          icon: Icon(
            size: 24,
            color: Theme.of(context).focusColor,
            context.platformIcon(
              material: Icons.menu,
              cupertino: CupertinoIcons.sidebar_left,
            ),
          ),
        ),
        trailing: !ref.watch(showAddButtonProvider)
            ? null
            : PlatformPopupMenu(
                icon: Icon(
                  color: Theme.of(context).focusColor,
                  size: 24,
                  context.platformIcon(
                    material: Icons.more_vert_rounded,
                    cupertino: CupertinoIcons.ellipsis,
                  ),
                ),
                options: [
                  PopupMenuOption(
                    label: '게시판 추가',
                    onTap: (_) => ref.read(handleAddButtonProvider(context)),
                  ),
                  PopupMenuOption(
                    label: '로그인',
                    onTap: (_) {
                      context.push<bool>(Routes.login).then((result) {
                        if (context.mounted && result == true) {
                          ref
                              .read(mainItemsNotifierProvider.notifier)
                              .refresh();
                        }
                      });
                    },
                  ),
                ],
              ),
      );
}
