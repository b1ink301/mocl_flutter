part of '../mocl_main_view.dart';

/// 홈 본문. 설정에 따라 두 가지로 그린다.
///
/// - 기본: 드로어에서 고른 사이트에 담아둔 게시판만([_SiteBody])
/// - 모든 사이트 모아 보기: 담은 게시판 전부를 사이트 머리글로 묶어서([_AllSitesBody])
///
/// 데이터는 같은 전역 즐겨찾기라 둘을 오가도 담은 게시판 · 사이트 안 순서는 같다.
class const _MainBody() extends ConsumerWidget with MainState {
  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      homeAllSitesState(ref) ? const _AllSitesBody() : const _SiteBody();
}

/// 지금 고른 사이트에 담아둔 게시판을 한 줄씩 펼친다.
///
/// 같은 카페(부모)의 게시판이 여럿이면 카페 소제목 아래로 한 번 더 묶는다
/// (2단 게시판). 그 밖에는 평평한 목록이라 탭 한 번이면 글 목록으로 들어간다.
class const _SiteBody() extends ConsumerWidget with MainState, FavoriteState {
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
      loading: () => const _LoadingBoards(),
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
      return _searchResults(
        favorites
            .where((favorite) => _matches(favorite, query, withSite: false))
            .toList(),
        query,
        bottom,
      );
    }

    if (favorites.isEmpty) {
      return const _EmptyBoards(allSites: false);
    }

    return SliverMainAxisGroup(
      slivers: [
        if (editMode)
          _ReorderableBoards(favorites: favorites)
        else //...[
          ..._buildSubSections(ref, favorites),
        // 광고는 게시판들 맨 아래에 하나만. 편집(드래그) · 검색 중에는 두지 않는다.
        // SliverToBoxAdapter(
        //   child: MainAdTile(styles: appTextStylesState(ref)),
        // ),
        //],
        // bottom 에는 떠 있는 탭바 높이가 들어온다(Scaffold extendBody).
        SliverToBoxAdapter(child: SizedBox(height: bottom)),
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
}

/// 모든 사이트의 담은 게시판을 사이트 머리글로 묶어 한 화면에 펼친다.
///
/// 사이트 안에서는 카페 소제목으로 한 번 더 묶지 않는다 — 사이트 → 카페 → 게시판
/// 세 겹이 되면 같은 이름을 거듭 읽게 된다(그룹 홈을 걷어낸 이유). 카페 이름은
/// 행 오른쪽 배지로만 밝힌다. 사이트 머리글을 눌러 접고, 접힘은 카페 소구획과
/// 같은 저장소(`CollapsedSubSections`)에 사이트 키로 남는다.
class const _AllSitesBody()
    extends ConsumerWidget
    with MainState, FavoriteState {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double bottom = MediaQuery.of(context).padding.bottom;

    return favoritesBySiteState(ref).when(
      skipLoadingOnReload: true,
      data: (sites) => _buildList(ref, sites, bottom),
      error: (error, _) =>
          _ErrorWidget(key: ValueKey(error.hashCode), error: error),
      loading: () => const _LoadingBoards(),
    );
  }

  Widget _buildList(WidgetRef ref, List<SiteFavorites> sites, double bottom) {
    final String query = searchQueryState(ref).trim().toLowerCase();

    if (query.isNotEmpty) {
      // 여러 사이트가 섞이므로 사이트 이름으로도 찾는다.
      return _searchResults(
        [
          for (final SiteFavorites site in sites)
            for (final FavoriteData favorite in site.items)
              if (_matches(favorite, query, withSite: true)) favorite,
        ],
        query,
        bottom,
      );
    }

    if (sites.isEmpty) {
      return const _EmptyBoards(allSites: true);
    }

    // 편집 중에는 접힌 사이트도 펼쳐 둔다(접힌 채로는 고칠 게 안 보인다).
    final bool editMode = editModeState(ref);
    final Set<String> collapsed = collapsedSubSectionsState(ref);

    return SliverMainAxisGroup(
      slivers: [
        for (final SiteFavorites site in sites)
          _siteSection(
            site,
            collapsed:
                !editMode &&
                collapsed.contains(siteSectionKeyOf(site.siteType)),
            editMode: editMode,
          ),
        // bottom 에는 떠 있는 탭바 높이가 들어온다(Scaffold extendBody).
        SliverToBoxAdapter(child: SizedBox(height: bottom)),
      ],
    );
  }

  Widget _siteSection(
    SiteFavorites site, {
    required bool collapsed,
    required bool editMode,
  }) => SliverMainAxisGroup(
    key: ValueKey('site_section_${site.siteType.name}'),
    slivers: [
      SliverToBoxAdapter(
        child: _SiteSectionHeader(
          siteType: site.siteType,
          count: site.items.length,
          collapsed: collapsed,
          editMode: editMode,
        ),
      ),
      // 순서는 사이트 안에서만 바꾼다(사이트별 보기와 같은 순서 값을 쓴다).
      if (editMode)
        _ReorderableBoards(favorites: site.items)
      else if (!collapsed)
        SliverList.builder(
          itemCount: site.items.length,
          itemBuilder: (context, index) => _BoardTile(
            key: ValueKey(_tileKeyOf(site.items[index])),
            favorite: site.items[index],
            index: index,
            editMode: false,
          ),
        ),
    ],
  );
}

/// 모아 보기의 사이트 접힘 키. 카페 소구획 키(`{site}_{parent}`)와 겹치지 않게 접두를 단다.
String siteSectionKeyOf(SiteType siteType) => 'site:${siteType.name}';

/// 모아 보기의 사이트 머리글. 눌러서 그 사이트의 게시판을 접거나 펼친다.
///
/// 게시판 행과 글자 크기만 달라서는 어디서 사이트가 바뀌는지 안 보였다. 그래서
/// 옅은 띠(배경 + 아래 헤어라인)를 깔고 사이트 로고를 앞에 둬, 행과 층이 다른
/// 머리글로 읽히게 한다. 강조색은 쓰지 않는다 — 탭바 · 칩의 선택 표시와 같은 색이면
/// 머리글이 "골라진 것" 처럼 보이고, 사이트 색 모드에서는 사이트마다 색이 바뀌어 산만하다.
/// 접으면 안이 안 보이므로 게시판 개수를 함께 두고, 화살표는 개수 바로 옆에 붙인다.
class const _SiteSectionHeader({
  required final SiteType siteType,
  required final int count,
  required final bool collapsed,
  required final bool editMode,
}) extends ConsumerWidget with MainState, MainEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final bool dark = theme.brightness == Brightness.dark;
    final Color subColor =
        theme.textTheme.bodySmall?.color ?? theme.colorScheme.onSurfaceVariant;
    final TextStyle base = smallTextStyleState(ref);

    return Semantics(
      identifier: 'main_site_${siteType.name}',
      button: !editMode,
      child: Material(
        color: dark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.black.withValues(alpha: 0.035),
        child: InkWell(
          onTap: editMode
              ? null
              : () => toggleSubSection(ref, siteSectionKeyOf(siteType)),
          child: Container(
            decoration: BoxDecoration(
              // 위쪽은 앞 사이트 마지막 행의 구분선이 이미 있어 아래만 긋는다.
              border: Border(
                bottom: BorderSide(color: theme.dividerColor, width: 0.5),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(16, 9, 12, 9),
            child: Row(
              children: [
                SiteAvatar(siteType: siteType, radius: 11),
                const SizedBox(width: 10),
                Flexible(
                  child: PlainText(
                    siteType.title,
                    style: base.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                PlainText(
                  '$count',
                  style: base.copyWith(
                    fontSize: (base.fontSize ?? 13) - 1,
                    fontWeight: FontWeight.w600,
                    color: subColor,
                  ),
                ),
                if (!editMode) ...[
                  const SizedBox(width: 2),
                  PlainIcon(
                    collapsed
                        ? Icons.chevron_right_rounded
                        : Icons.expand_more_rounded,
                    size: 18,
                    color: subColor,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 처음 불러오는 동안.
class const _LoadingBoards() extends ConsumerWidget with MainState {
  @override
  Widget build(BuildContext context, WidgetRef ref) => SliverFillRemaining(
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
  );
}

/// 내 게시판 검색 결과. 소구획 · 사이트로 묶지 않는다(어느 카페 것인지는 배지,
/// 어느 사이트 것인지는 행 왼쪽 아이콘으로 밝힌다).
Widget _searchResults(List<FavoriteData> hits, String query, double bottom) {
  if (hits.isEmpty) {
    return _NoSearchResult(query: query);
  }
  return SliverMainAxisGroup(
    slivers: [
      SliverList.builder(
        itemCount: hits.length,
        itemBuilder: (context, index) => _BoardTile(
          key: ValueKey(_tileKeyOf(hits[index])),
          favorite: hits[index],
          index: index,
          editMode: false,
        ),
      ),
      SliverToBoxAdapter(child: SizedBox(height: bottom)),
    ],
  );
}

/// 담은 게시판이 없을 때. 담기로 바로 잇는다. 사이트별 보기에서는 다른 사이트
/// 고르기도 둔다(모아 보기는 드로어가 없고, 비었다면 어느 사이트에도 없다).
class const _EmptyBoards({required final bool allSites})
    extends ConsumerWidget
    with MainState, MainEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) => SliverMessageView(
    child: MessageView(
      icon: Icons.playlist_add,
      title: '담은 게시판이 없어요',
      description: allSites
          ? '자주 보는 게시판을 담아 두면 사이트별로 여기에 모여요.'
          : '${titleState(ref)}에서 자주 보는 게시판을 담아 두면 여기에 모여요.',
      primaryLabel: '게시판 담기',
      onPrimary: () => handleAddButton(ref, context),
      secondaryLabel: allSites ? null : '다른 사이트',
      onSecondary: allSites ? null : () => openSiteDrawer(context),
      titleStyle: titleTextStyleState(ref),
      descriptionStyle: smallTextStyleState(ref),
    ),
  );
}

/// 내 게시판 검색 결과가 없을 때.
class const _NoSearchResult({required final String query})
    extends ConsumerWidget
    with MainState {
  @override
  Widget build(BuildContext context, WidgetRef ref) => SliverMessageView(
    child: MessageView(
      icon: Icons.search_off,
      title: '맞는 게시판이 없어요',
      description: "'$query' 가 들어간 게시판을 담아 두지 않았어요.",
      titleStyle: titleTextStyleState(ref),
      descriptionStyle: smallTextStyleState(ref),
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
/// 사이트별 보기는 목록이 이미 한 사이트라 사이트 이름을 보지 않고([withSite] false),
/// 모아 보기는 여러 사이트가 섞여 사이트 이름으로도 찾는다.
bool _matches(FavoriteData favorite, String query, {required bool withSite}) =>
    favorite.text.toLowerCase().contains(query) ||
    favorite.parentText.toLowerCase().contains(query) ||
    (withSite && favorite.siteType.title.toLowerCase().contains(query));

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
    final Color subColor =
        theme.textTheme.bodySmall?.color ?? theme.colorScheme.onSurfaceVariant;

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
    final Color color =
        theme.textTheme.bodySmall?.color ?? theme.colorScheme.onSurfaceVariant;

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
    final primaryColor = Theme.of(context).colorScheme.primary;
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
                          color: Theme.of(context).colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.55),
                        )
                      : _OriginBadge(text: origin))
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PlainIconButton(
                        semanticLabel: '게시판 빼기',
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
    extends ConsumerWidget
    with MainState, FavoriteEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) => SliverMessageView(
    child: FailureView(
      error: error,
      onRetry: () => refreshFavorites(ref),
      titleStyle: titleTextStyleState(ref),
      descriptionStyle: smallTextStyleState(ref),
    ),
  );
}
