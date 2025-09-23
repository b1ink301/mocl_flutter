part of '../mocl_main_view.dart';

class _MainBody extends ConsumerWidget with MainState, MainEvent {
  const _MainBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    listenNotLoginFailure(ref, context);
    return mainState(ref).when(
      data: (data) => SliverPadding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        sliver: _BodyList(key: ValueKey(data.hashCode), items: data),
      ),
      error: (error, _) => _ErrorWidget(
        key: ValueKey(error.hashCode),
        message: error is Failure ? error.message : error.toString(),
      ),
      loading: () => const SliverToBoxAdapter(
        child: Column(children: [LoadingWidget(), DividerWidget()]),
      ),
    );
  }
}

class _BodyList extends ConsumerWidget with MainState {
  final List<MainItem> items;

  const _BodyList({super.key, required this.items});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyle = titleTextStyleSate(ref);
    return items.isEmpty
        ? _buildEmptyView(textStyle)
        : SliverList.separated(
            itemCount: items.length,
            itemBuilder: (context, index) =>
                _buildListItem(context, items[index], textStyle),
            separatorBuilder: (_, _) => const DividerWidget(),
          );
  }

  Widget _buildEmptyView(TextStyle? textStyle) => SliverFillRemaining(
    hasScrollBody: false,
    child: Center(
      child: PlatformText('항목이 없습니다.\n항목을 추가해 주세요!', style: textStyle),
    ),
  );

  Widget _buildListItem(
    BuildContext context,
    MainItem item,
    TextStyle? textStyle,
  ) => PlatformListTile(
    key: ValueKey(item.board),
    leading: item.icon.isEmpty ? null : _buildIconView(item.icon),
    title: PlatformText(item.text, style: textStyle),
    onTap: () => context.push(Routes.list, extra: item),
    material: (_, _) => MaterialListTileData(
      contentPadding: const EdgeInsets.fromLTRB(16, 4, 8, 4),
    ),
    cupertino: (_, _) => CupertinoListTileData(
      padding: const EdgeInsets.fromLTRB(16, 18, 8, 18),
      additionalInfo: const Icon(CupertinoIcons.chevron_forward),
    ),
  );

  Widget _buildIconView(String url) => CircleAvatar(
    radius: 20,
    backgroundImage: CachedNetworkImageProvider(url),
  );
}

class _ErrorWidget extends StatelessWidget {
  final String message;

  const _ErrorWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) => SliverPadding(
    padding: const EdgeInsets.all(12.0),
    sliver: SliverToBoxAdapter(
      child: PlatformText(
        message,
        style: TextStyle(fontSize: 16, color: Theme.of(context).focusColor),
      ),
    ),
  );
}

class _MainAppBar extends ConsumerWidget with MainState, MainEvent {
  const _MainAppBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) => SliverAppBar(
    scrolledUnderElevation: 0,
    title: PlatformText(titleState(ref)),
    titleTextStyle: AppTextStyles.of(
      context,
    ).titleTextStyle.copyWith(color: Colors.white),
    titleSpacing: 0,
    floating: true,
    toolbarHeight: 62,
    actions: [
      if (showAddButtonState(ref))
        PlatformIconButton(
          onPressed: () => handleAddButton(ref, context),
          icon: const Icon(Icons.add),
        ),
      PlatformPopupMenu(
        options: [
          PopupMenuOption(
            label: '로그인',
            onTap: (_) => handleLogin(ref, context),
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

class _MainNavigationBar extends ConsumerWidget with MainState, MainEvent {
  const _MainNavigationBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      CupertinoSliverNavigationBar(
        largeTitle: PlatformText(titleState(ref)),
        padding: const EdgeInsetsDirectional.only(start: 5, end: 10),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: PlatformIconButton(
          padding: const EdgeInsets.all(0),
          onPressed: () => handleSideBarToggle(ref),
          icon: Icon(
            size: 24,
            color: Theme.of(context).focusColor,
            context.platformIcon(
              material: Icons.menu,
              cupertino: CupertinoIcons.sidebar_left,
            ),
          ),
        ),
        trailing: showAddButtonState(ref)
            ? PlatformPopupMenu(
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
                    onTap: (_) => handleAddButton(ref, context),
                  ),
                  PopupMenuOption(
                    label: '로그인',
                    onTap: (_) => handleLogin(ref, context),
                  ),
                ],
              )
            : null,
      );
}
