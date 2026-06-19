part of '../mocl_main_view.dart';

class _MainBody extends ConsumerWidget with MainState, MainEvent {
  const _MainBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    listenNotLoginFailure(ref, context);
    final bottom = MediaQuery.of(context).padding.bottom;

    return mainState(ref).when(
      data: (data) => SliverPadding(
        padding: .only(bottom: bottom),
        sliver: _BodyList(key: ValueKey(data.hashCode), items: data),
      ),
      error: (error, _) => _ErrorWidget(
        key: ValueKey(error.hashCode),
        message: error is Failure ? error.message : error.toString(),
      ),
      loading: () => SliverFillRemaining(
        hasScrollBody: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            const LoadingWidget(),
            PlainText(
              '로딩 중...',
              style: ref.watch(appTextStylesFontSizeProvider).smallTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}

class _BodyList extends ConsumerWidget with MainState, MainEvent {
  final List<MainItem> items;

  const _BodyList({super.key, required this.items});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyle = titleTextStyleState(ref);
    if (items.isEmpty) return _buildEmptyView(textStyle);
    return SliverReorderableList(
      itemCount: items.length,
      onReorderItem: (oldIndex, newIndex) =>
          handleReorder(ref, oldIndex, newIndex),
      itemBuilder: (context, index) =>
          _buildListItem(context, items[index], textStyle, index),
    );
  }

  Widget _buildEmptyView(TextStyle? textStyle) => SliverFillRemaining(
    hasScrollBody: false,
    child: Center(child: Text('항목이 없습니다.\n항목을 추가해 주세요!', style: textStyle)),
  );

  // 항목마다 고유 Key 가 필요하다(siteType+board 조합으로 유일).
  Widget _buildListItem(
    BuildContext context,
    MainItem item,
    TextStyle? textStyle,
    int index,
  ) {
    final primaryColor = Theme.of(context).primaryColor;
    return Material(
      // ReorderableList 항목은 Material 조상을 상속받지 못해 ListTile 이 assert 됨.
      // 항목마다 투명 Material 을 둬 ListTile/잉크 효과가 동작하게 한다.
      key: ValueKey('${item.siteType.name}_${item.board}'),
      type: MaterialType.transparency,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: item.icon.isEmpty ? null : _buildIconView(item.icon),
            title: PlainText(item.text, style: textStyle!),
            trailing: ReorderableDragStartListener(
              index: index,
              child: PlainIcon(Icons.drag_handle, color: primaryColor),
            ),
            onTap: () => context.push(Routes.list, extra: item),
            contentPadding: const .fromLTRB(16, 4, 18, 4),
          ),
          const PlainDividerWidget(),
        ],
      ),
    );
  }

  Widget _buildIconView(String url) => CircleAvatar(
    radius: 20,
    backgroundImage: CachedNetworkImageProvider(url),
  );
}

class _ErrorWidget extends StatelessWidget {
  final String message;

  const _ErrorWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final focusColor = Theme.of(context).focusColor;
    return SliverPadding(
      padding: const .all(12.0),
      sliver: SliverToBoxAdapter(
        child: PlainText(
          message,
          style: TextStyle(fontSize: 16, color: focusColor),
        ),
      ),
    );
  }
}

class _MainAppBar extends ConsumerWidget with MainState, MainEvent {
  const _MainAppBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleStyle = ref.watch(appbarTextStyleProvider);
    return SliverAppBar(
      scrolledUnderElevation: 0,
      title: PlainText(titleState(ref), style: titleStyle),
      titleTextStyle: titleStyle,
      titleSpacing: 0,
      floating: true,
      toolbarHeight: 62,
      actions: [
        if (showAddButtonState(ref))
          PlainIconButton(
            onPressed: () => handleAddButton(ref, context),
            icon: const PlainIcon(Icons.add),
          ),
        if (currentSiteType(ref).supportsLogin)
          AdaptivePopupMenu(
            options: [
              AdaptiveMenuOption(
                label: '로그인',
                onTap: () => handleLogin(ref, context),
              ),
            ],
            icon: PlainIcon(
              isCupertino() ? CupertinoIcons.ellipsis : Icons.more_vert_rounded,
            ),
          ),
      ],
    );
  }
}
