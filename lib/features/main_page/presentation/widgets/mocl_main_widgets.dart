part of '../mocl_main_view.dart';

/// 홈 본문. 지금 고른 사이트에 담아둔 게시판을 한 줄씩 펼친다.
///
/// 같은 카페(부모)의 게시판이 여럿이면 카페 소제목 아래로 한 번 더 묶는다
/// (2단 게시판). 그 밖에는 평평한 목록이라 탭 한 번이면 글 목록으로 들어간다.
class const _MainBody() extends ConsumerWidget with MainState, FavoriteState {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double bottom = MediaQuery.of(context).padding.bottom;

    return siteFavoritesState(ref).when(
      // 추가·삭제·순서 변경마다 목록 전체가 '로딩 중'으로 깜빡이지 않도록,
      // 갱신 중에는 직전 목록을 그대로 유지한다.
      skipLoadingOnReload: true,
      data: (favorites) => _buildList(ref, favorites, bottom),
      error: (error, _) =>
          _ErrorWidget(key: ValueKey(error.hashCode), error: error),
      loading: () => SliverFillRemaining(
        hasScrollBody: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            const LoadingWidget(),
            PlainText('로딩 중...', style: smallTextStyleState(ref)),
          ],
        ),
      ),
    );
  }

  Widget _buildList(
    WidgetRef ref,
    List<FavoriteData> favorites,
    double bottom,
  ) {
    final String query = searchQueryState(ref).trim().toLowerCase();
    // 검색 중에는 정렬(드래그)을 쓸 수 없다 — 걸러진 목록의 인덱스는
    // 저장할 순서와 다르다.
    final bool editMode = editModeState(ref) && query.isEmpty;

    if (query.isNotEmpty) {
      final List<FavoriteData> hits = favorites
          .where((favorite) => _matches(favorite, query))
          .toList();
      if (hits.isEmpty) {
        return _buildNoResultView(titleTextStyleState(ref), query);
      }
      return SliverMainAxisGroup(
        slivers: [
          // 검색 결과는 소구획으로 묶지 않는다(어느 카페 것인지는 배지로 밝힌다).
          SliverList.builder(
            itemCount: hits.length,
            itemBuilder: (context, index) => _BoardTile(
              key: ValueKey(_tileKeyOf(hits[index])),
              favorite: hits[index],
              index: index,
              editMode: false,
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: bottom + 8)),
        ],
      );
    }

    if (favorites.isEmpty) {
      return _buildEmptyView(titleTextStyleState(ref), titleState(ref));
    }

    return SliverMainAxisGroup(
      slivers: [
        if (editMode)
          _ReorderableBoards(favorites: favorites)
        else
          ..._buildSubSections(ref, favorites),
        // bottom 에는 떠 있는 탭바 높이가 들어온다(Scaffold extendBody).
        SliverToBoxAdapter(child: SizedBox(height: bottom + 8)),
      ],
    );
  }

  /// 같은 카페의 게시판을 소제목 아래로 묶어 그린다.
  /// 부모가 없는(또는 혼자인) 항목은 예전처럼 평평하게 이어진다.
  List<Widget> _buildSubSections(WidgetRef ref, List<FavoriteData> favorites) {
    final List<FavoriteSubSection> subSections = subSectionsOf(favorites);
    final Set<String> collapsed = collapsedSubSectionsState(ref);

    return [
      for (final FavoriteSubSection sub in subSections)
        if (sub.key.isEmpty)
          SliverList.builder(
            itemCount: sub.items.length,
            itemBuilder: (context, itemIndex) => _BoardTile(
              key: ValueKey(_tileKeyOf(sub.items[itemIndex])),
              favorite: sub.items[itemIndex],
              index: itemIndex,
              editMode: false,
            ),
          )
        else
          SliverMainAxisGroup(
            slivers: [
              SliverToBoxAdapter(
                child: _SubSectionHeader(
                  sub: sub,
                  collapsed: collapsed.contains(sub.key),
                ),
              ),
              if (!collapsed.contains(sub.key))
                SliverList.builder(
                  itemCount: sub.items.length,
                  itemBuilder: (context, itemIndex) => _BoardTile(
                    key: ValueKey(_tileKeyOf(sub.items[itemIndex])),
                    favorite: sub.items[itemIndex],
                    index: itemIndex,
                    editMode: false,
                    // 소제목이 이미 카페를 밝히므로 행에서는 출처를 지운다.
                    inSubSection: true,
                  ),
                ),
            ],
          ),
    ];
  }

  Widget _buildNoResultView(TextStyle textStyle, String query) =>
      SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: PlainText(
              "'$query' 와 맞는 게시판이 없습니다.",
              textAlign: TextAlign.center,
              style: textStyle,
            ),
          ),
        ),
      );

  Widget _buildEmptyView(
    TextStyle textStyle,
    String siteTitle,
  ) => SliverFillRemaining(
    hasScrollBody: false,
    child: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Text(
          '$siteTitle 에서 담은 게시판이 없습니다.\n오른쪽 위 + 로 게시판을 담거나,\n왼쪽 위 ☰ 로 다른 사이트를 골라 보세요.',
          textAlign: TextAlign.center,
          style: textStyle,
        ),
      ),
    ),
  );
}

/// 편집 모드의 드래그 정렬 목록.
///
/// 편집 중에는 소구획으로 묶지 않는다 — 드래그가 평면 인덱스를 쓰므로
/// 묶어버리면 카페를 넘나드는 순서 변경을 할 수 없다.
class const _ReorderableBoards({required final List<FavoriteData> favorites})
    extends ConsumerWidget
    with FavoriteEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) => SliverReorderableList(
    itemCount: favorites.length,
    onReorderItem: (oldIndex, newIndex) =>
        reorderFavoriteInSite(ref, favorites, oldIndex, newIndex),
    itemBuilder: (context, index) => _BoardTile(
      key: ValueKey(_tileKeyOf(favorites[index])),
      favorite: favorites[index],
      index: index,
      editMode: true,
    ),
  );
}

/// 항목마다 고유 Key 가 필요하다(사이트+게시판 조합으로 유일).
String _tileKeyOf(FavoriteData favorite) =>
    '${favorite.siteType.name}_${favorite.board}';

/// 검색어가 게시판 이름이나 카페 이름에 걸리는지.
/// (목록이 이미 한 사이트로 좁혀져 있어 사이트 이름은 볼 필요가 없다)
bool _matches(FavoriteData favorite, String query) =>
    favorite.text.toLowerCase().contains(query) ||
    favorite.parentText.toLowerCase().contains(query);

/// 컨테이너(카페) 자체를 담은 항목인지. 하위 메뉴 목록의 '전체글' 이 이렇게
/// 저장된다(board 가 부모와 같다). 이 항목만 제목이 '전체글' 이라 여러 카페를
/// 담으면 구분이 안 되므로, 소제목 밖에서는 카페 이름을 제목으로 쓴다.
bool _isWholeContainer(FavoriteData favorite) =>
    favorite.parentBoard.isNotEmpty && favorite.board == favorite.parentBoard;

/// 행에 보일 제목.
String _titleOf(FavoriteData favorite, {required bool inSubSection}) =>
    !inSubSection &&
        _isWholeContainer(favorite) &&
        favorite.parentText.isNotEmpty
    ? favorite.parentText
    : favorite.text;

/// 행에 붙일 출처(카페 이름). 소제목이 이미 밝혀주면 비우고, 부제 대신
/// 오른쪽 배지로 붙여 행 높이를 한 줄로 유지한다.
String _originOf(FavoriteData favorite, {required bool inSubSection}) =>
    !inSubSection &&
        !_isWholeContainer(favorite) &&
        favorite.parentText.isNotEmpty
    ? favorite.parentText
    : '';

/// 카페(부모) 소제목 한 줄. 눌러서 그 카페의 게시판을 접거나 펼친다.
///
/// 행보다 한 칸 들여쓰고 배경을 옅게 깔아 목록과 층을 나눈다. 접었을 때
/// 카페 하나가 한 줄로 줄어드는 게 이 소제목의 값이다.
class const _SubSectionHeader({
  required final FavoriteSubSection sub,
  required final bool collapsed,
}) extends ConsumerWidget with MainState, MainEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final Color subColor = theme.textTheme.bodySmall?.color ?? theme.hintColor;

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () => toggleSubSection(ref, sub.key),
        child: Container(
          color: theme.brightness == Brightness.dark
              ? Colors.white.withValues(alpha: 0.03)
              : Colors.black.withValues(alpha: 0.02),
          padding: const EdgeInsets.fromLTRB(16, 9, 12, 9),
          child: Row(
            children: [
              Flexible(
                child: PlainText(
                  sub.parentText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              PlainText(
                '${sub.items.length}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: subColor,
                ),
              ),
              const SizedBox(width: 6),
              PlainIcon(
                collapsed
                    ? Icons.chevron_right_rounded
                    : Icons.expand_more_rounded,
                size: 18,
                color: subColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 행 오른쪽에 붙는 출처(카페) 배지.
/// 부제로 내리면 행이 두 줄이 되어 목록의 리듬이 깨지므로 오른쪽에 둔다.
class const _OriginBadge({required final String text}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color color = theme.textTheme.bodySmall?.color ?? theme.hintColor;

    return Container(
      constraints: const BoxConstraints(maxWidth: 130),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: theme.dividerColor),
      ),
      child: PlainText(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 10.5, color: color),
      ),
    );
  }
}

/// 담아둔 게시판 한 줄. 평소엔 탭으로 진입하고,
/// 편집 모드에선 드래그=순서 변경 / X=삭제 로 동작한다.
class const _BoardTile({
  super.key,
  required final FavoriteData favorite,
  required final int index,
  required final bool editMode,
  final bool inSubSection = false,
}) extends ConsumerWidget with MainState, MainEvent, FavoriteEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryColor = Theme.of(context).primaryColor;
    final String origin = _originOf(favorite, inSubSection: inSubSection);

    return Material(
      // ReorderableList 항목은 Material 조상을 상속받지 못해 ListTile 이 assert 됨.
      // 항목마다 투명 Material 을 둬 ListTile/잉크 효과가 동작하게 한다.
      type: MaterialType.transparency,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            // 아이콘이 없는 사이트도 색 배지로 채워 줄을 가지런히 맞춘다.
            // 설정에서 끄면 제목만 남아 목록이 담백해진다.
            leading: showBoardIconState(ref) && favorite.icon.isNotEmpty
                ? SiteAvatar(
                    siteType: favorite.siteType,
                    iconUrl: favorite.icon,
                  )
                : null,
            title: PlainText(
              _titleOf(favorite, inSubSection: inSubSection),
              style: titleTextStyleState(ref),
            ),
            // 출처는 평소에 오른쪽 배지로 붙여 모든 행을 한 줄로 맞춘다.
            // 편집 모드에선 오른쪽이 버튼 차지라 부제로 내린다(높이가 흔들려도
            // 편집 중에는 어느 카페 것인지 아는 편이 낫다).
            subtitle: editMode && origin.isNotEmpty
                ? PlainText(origin, style: smallTextStyleState(ref))
                : null,
            // 진입 표시는 iOS 설정 앱처럼 작고 옅은 회색 셰브론으로 둔다.
            // 강조색·큰 아이콘은 제목보다 먼저 눈에 띄어 목록 균형을 깨뜨린다.
            trailing: !editMode
                ? (origin.isEmpty
                      ? PlainIcon(
                          Icons.chevron_right_rounded,
                          size: 20,
                          color: Theme.of(context).hintColor
                              .withValues(alpha: 0.55),
                        )
                      : _OriginBadge(text: origin))
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PlainIconButton(
                        icon: const PlainIcon(Icons.close_rounded),
                        onPressed: () => removeFavorite(
                          ref,
                          favorite.siteType,
                          favorite.board,
                        ),
                      ),
                      ReorderableDragStartListener(
                        index: index,
                        child: PlainIcon(
                          Icons.drag_handle,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
            // 편집 중에는 탭이 실수로 화면을 떠나게 만드므로 막는다.
            onTap: editMode ? null : () => _openBoard(context, ref),
            contentPadding: const EdgeInsets.fromLTRB(16, 2, 12, 2),
          ),
          // 구분선은 제목 시작선(왼쪽 16)에 맞춰 들여 넣고 오른쪽은 끝까지 채운다.
          const PlainDividerWidget(indent: 16, endIndent: 0),
        ],
      ),
    );
  }

  /// 리스트/파서는 전역 currentSiteType 을 따른다. 홈이 이미 그 사이트를
  /// 보고 있지만, 검색 결과처럼 다른 경로로 열릴 때를 위해 맞춰두고 들어간다.
  void _openBoard(BuildContext context, WidgetRef ref) {
    changeSiteType(ref, favorite.siteType);
    context.push(Routes.list, extra: favorite.toMainItem());
  }
}

class const _ErrorWidget({super.key, required final Object? error})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SliverFillRemaining(
    hasScrollBody: false,
    child: Center(child: FailureView(error: error)),
  );
}

class const _MainAppBar() extends ConsumerWidget with MainState, MainEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleStyle = ref.watch(appbarTextStyleProvider);
    final bool editMode = editModeState(ref);
    final bool searchOpen = searchOpenState(ref);

    return SliverAppBar(
      scrolledUnderElevation: 1,
      // Scaffold 기본 leading(DrawerButton = Icons.menu) 대신 직접 그린
      // 메뉴 아이콘을 쓴다. 액션들과 같은 PlainIconButton 이라 floating
      // 앱바의 toolbarOpacity 변화에도 불필요한 리빌드가 없다.
      leading: PlainIconButton(
        onPressed: () => openDrawer(ref),
        icon: const MenuLinesIcon(),
      ),
      // 검색 중에는 입력창이 제목 자리를 통째로 쓴다(닫기 버튼만 오른쪽에 남는다).
      title: searchOpen
          ? const _SearchField()
          : PlainText(editMode ? '편집' : titleState(ref), style: titleStyle),
      titleTextStyle: titleStyle,
      titleSpacing: 0,
      floating: true,
      centerTitle: false,
      toolbarHeight: kToolbarHeight,
      // floating 앱바의 toolbarOpacity 로 인한 PlainIcon 리빌드 차단.
      // (AppbarActionsIconTheme 주석 참고)
      actions: <Widget>[
        AppbarActionsIconTheme(
          children: searchOpen
              // 검색 중에는 닫기만 남긴다(입력창이 앱바를 다 쓴다).
              ? [
                  PlainIconButton(
                    onPressed: () => closeSearch(ref),
                    icon: const PlainIcon(Icons.close),
                  ),
                ]
              : editMode
              ? [
                  PlainIconButton(
                    onPressed: () => handleToggleEdit(ref),
                    icon: const PlainIcon(Icons.check),
                  ),
                ]
              : [
                  // 담은 게시판이 많아지면 스크롤보다 검색이 빠르다.
                  // PlainIconButton(
                  //   onPressed: () => openSearch(ref),
                  //   icon: const PlainIcon(Icons.search),
                  // ),
                  PlainIconButton(
                    onPressed: () => handleAddButton(ref, context),
                    icon: const PlainIcon(Icons.add),
                  ),
                  // 순서 변경 · 삭제는 평소엔 숨겨 두고 편집 모드에서만 연다.
                  AdaptivePopupMenu(
                    options: [
                      AdaptiveMenuOption(
                        label: '순서 변경/삭제',
                        onTap: () => handleToggleEdit(ref),
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

/// 앱바 자리에 들어가는 게시판 검색 입력창.
class const _SearchField() extends ConsumerStatefulWidget {
  @override
  ConsumerState<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState()
    extends ConsumerState<_SearchField>
    with MainState, MainEvent {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: readSearchQuery(ref));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color hintColor = theme.textTheme.bodySmall?.color ?? theme.hintColor;

    return TextField(
      controller: _controller,
      autofocus: true,
      textInputAction: TextInputAction.search,
      style: theme.textTheme.bodyLarge,
      onChanged: (value) => updateSearchQuery(ref, value),
      decoration: InputDecoration(
        isDense: true,
        border: InputBorder.none,
        hintText: '담은 게시판 검색',
        hintStyle: TextStyle(fontSize: 15, color: hintColor),
      ),
    );
  }
}
