part of '../mocl_main_view.dart';

class const _MainBody() extends ConsumerWidget with MainState, MainEvent {
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

class const _BodyList({super.key, required final List<MainItem> items})
    extends ConsumerWidget
    with MainState, MainEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyle = titleTextStyleState(ref);
    if (items.isEmpty) return _buildEmptyView(textStyle);

    final bool reorderMode = reorderModeState(ref);
    // 정렬 모드일 때만 드래그로 순서 변경. 평소엔 일반 목록(탭=이동).
    if (reorderMode) {
      return SliverReorderableList(
        itemCount: items.length,
        onReorderItem: (oldIndex, newIndex) =>
            handleReorder(ref, oldIndex, newIndex),
        itemBuilder: (context, index) =>
            _buildListItem(context, items[index], textStyle, index, true),
      );
    }
    return SliverList.builder(
      itemCount: items.length,
      itemBuilder: (context, index) =>
          _buildListItem(context, items[index], textStyle, index, false),
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
    bool reorderMode,
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
            // 정렬 모드에서만 드래그 핸들 노출 + 탭 이동 비활성화.
            // 평소엔 즐겨찾기 별 버튼(사이트 상관없이 드로어에 모임).
            trailing: reorderMode
                ? ReorderableDragStartListener(
                    index: index,
                    child: PlainIcon(Icons.drag_handle, color: primaryColor),
                  )
                : null,
            // : _FavoriteStar(item: item),
            onTap: reorderMode
                ? null
                : () => context.push(Routes.list, extra: item),
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

/// 메인 게시판 목록의 즐겨찾기 별 버튼. 켜지면 채워진 별(강조색),
/// 꺼지면 빈 별. 사이트 경계를 넘어 드로어 '즐겨찾기' 섹션에 모인다.
class const _FavoriteStar({required final MainItem item})
    extends ConsumerWidget
    with FavoriteState, FavoriteEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isFav = isFavoriteState(ref, item.siteType, item.board);
    final Color primaryColor = Theme.of(context).primaryColor;
    return PlainIconButton(
      onPressed: () => toggleFavorite(ref, item),
      icon: PlainIcon(
        isFav ? Icons.star_rounded : Icons.star_border_rounded,
        color: isFav ? primaryColor : null,
      ),
    );
  }
}

class const _ErrorWidget({super.key, required final String message})
    extends StatelessWidget {
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

class const _MainAppBar() extends ConsumerWidget with MainState, MainEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleStyle = ref.watch(appbarTextStyleProvider);
    return SliverAppBar(
      scrolledUnderElevation: 1,
      title: PlainText(titleState(ref), style: titleStyle),
      titleTextStyle: titleStyle,
      titleSpacing: 0,
      floating: true,
      toolbarHeight: 62,
      // floating 앱바의 toolbarOpacity 로 인한 PlainIcon 리빌드 차단.
      // (AppbarActionsIconTheme 주석 참고)
      actions: <Widget>[
        AppbarActionsIconTheme(
          children: reorderModeState(ref)
              // 정렬 모드: '완료' 로 빠져나간다.
              ? [
                  PlainIconButton(
                    onPressed: () => handleToggleReorder(ref),
                    icon: const PlainIcon(Icons.check),
                  ),
                ]
              : [
                  if (showAddButtonState(ref))
                    PlainIconButton(
                      onPressed: () => handleAddButton(ref, context),
                      icon: const PlainIcon(Icons.add),
                    ),
                  AdaptivePopupMenu(
                    options: [
                      AdaptiveMenuOption(
                        label: '항목 정렬',
                        onTap: () => handleToggleReorder(ref),
                      ),
                      if (currentSiteType(ref).supportsLogin)
                        AdaptiveMenuOption(
                          label: '로그인',
                          onTap: () => handleLogin(ref, context),
                        ),
                    ],
                    icon: PlainIcon(
                      isCupertino()
                          ? CupertinoIcons.ellipsis
                          : Icons.more_vert_rounded,
                    ),
                  ),
                ],
        ),
      ],
    );
  }
}
