part of '../mocl_main_view.dart';

/// 메인 화면 본문. 사이트를 가리지 않고, 사용자가 등록한 게시판을
/// 그룹(카테고리)별로 묶어 한 화면에 펼쳐 보여준다.
class const _MainBody() extends ConsumerWidget
    with MainState, FavoriteState, FavoriteEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double bottom = MediaQuery.of(context).padding.bottom;

    return favoriteSectionsState(ref).when(
      // 추가·삭제·순서 변경마다 목록 전체가 '로딩 중'으로 깜빡이지 않도록,
      // 갱신 중에는 직전 목록을 그대로 유지한다.
      skipLoadingOnReload: true,
      data: (sections) => _buildSections(ref, sections, bottom),
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
            PlainText('로딩 중...', style: smallTextStyleState(ref)),
          ],
        ),
      ),
    );
  }

  Widget _buildSections(
    WidgetRef ref,
    List<FavoriteSection> sections,
    double bottom,
  ) {
    final bool editMode = editModeState(ref);
    // 평소엔 빈 그룹을 감춰 목록을 짧게 유지하고, 편집 모드에선 이름 변경 ·
    // 삭제 · 이동 대상이 되도록 빈 그룹까지 모두 보여준다.
    final List<FavoriteSection> visible = editMode
        ? sections
        : sections.where((section) => section.items.isNotEmpty).toList();

    if (visible.isEmpty) {
      return _buildEmptyView(titleTextStyleState(ref));
    }

    return SliverMainAxisGroup(
      slivers: [
        for (int i = 0; i < visible.length; i++)
          ..._buildSection(ref, visible[i], i, visible.length, editMode),
        // bottom 에는 떠 있는 탭바 높이가 들어온다(Scaffold extendBody).
        SliverToBoxAdapter(child: SizedBox(height: bottom + 8)),
      ],
    );
  }

  List<Widget> _buildSection(
    WidgetRef ref,
    FavoriteSection section,
    int index,
    int total,
    bool editMode,
  ) => [
    SliverToBoxAdapter(
      child: _GroupHeader(
        group: section.group,
        count: section.items.length,
        index: index,
        total: total,
        editMode: editMode,
      ),
    ),
    // 접어둔 그룹은 헤더만 남긴다.
    if (section.group.collapsed)
      const SliverToBoxAdapter(child: SizedBox.shrink())
    // 편집 모드에서만 드래그로 그룹 안 순서를 바꾼다(평소엔 탭=게시판 이동).
    else if (editMode)
      SliverReorderableList(
        key: ValueKey('reorder_${section.group.id}'),
        itemCount: section.items.length,
        onReorderItem: (oldIndex, newIndex) => reorderFavoriteInGroup(
          ref,
          section.group.id,
          section.items,
          oldIndex,
          newIndex,
        ),
        itemBuilder: (context, itemIndex) => _BoardTile(
          key: ValueKey(_tileKeyOf(section.items[itemIndex])),
          favorite: section.items[itemIndex],
          index: itemIndex,
          editMode: true,
          showSite: _needsSiteLabel(section, itemIndex),
        ),
      )
    else
      SliverList.builder(
        itemCount: section.items.length,
        itemBuilder: (context, itemIndex) => _BoardTile(
          key: ValueKey(_tileKeyOf(section.items[itemIndex])),
          favorite: section.items[itemIndex],
          index: itemIndex,
          editMode: false,
          showSite: _needsSiteLabel(section, itemIndex),
        ),
      ),
  ];

  Widget _buildEmptyView(TextStyle textStyle) => SliverFillRemaining(
    hasScrollBody: false,
    child: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Text(
          '아직 추가한 게시판이 없습니다.\n오른쪽 위 + 를 눌러\n자주 보는 게시판을 추가해 보세요.',
          textAlign: TextAlign.center,
          style: textStyle,
        ),
      ),
    ),
  );
}

/// 항목마다 고유 Key 가 필요하다(사이트+게시판 조합으로 유일).
String _tileKeyOf(FavoriteData favorite) =>
    '${favorite.siteType.name}_${favorite.board}';

/// 그룹이 곧 그 사이트를 뜻하면(사이트별 자동 그룹) 항목마다 사이트명을
/// 반복할 필요가 없다. 사용자가 다른 사이트 게시판을 끌어와 섞은 그룹에서만
/// 출처를 밝힌다.
bool _needsSiteLabel(FavoriteSection section, int index) =>
    section.group.id != section.items[index].siteType.name;

/// 그룹 이름 줄. 눌러서 접거나 펼칠 수 있고,
/// 편집 모드에서는 위/아래 이동 · 이름 변경 · 삭제 버튼이 붙는다.
class const _GroupHeader({
  required final FavoriteGroup group,
  required final int count,
  required final int index,
  required final int total,
  required final bool editMode,
}) extends ConsumerWidget with MainState, FavoriteEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    // final Color labelColor = theme.textTheme.bodySmall?.color ?? theme.hintColor;
    final Color labelColor = theme.primaryColor;
    final TextStyle labelStyle = TextStyle(
      fontSize: 11.5,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.5,
      color: labelColor,
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(8, index == 0 ? 10 : 18, 8, 4),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => toggleGroupCollapsed(ref, group.id),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 6, 8, 6),
                child: Row(
                  children: [
                    // 접힘 여부를 화살표로 알린다(접힘 ▸ / 펼침 ▾).
                    Icon(
                      group.collapsed
                          ? Icons.chevron_right_rounded
                          : Icons.expand_more_rounded,
                      size: 18,
                      color: labelColor,
                    ),
                    const SizedBox(width: 2),
                    Flexible(child: PlainText(group.name, style: labelStyle)),
                    const SizedBox(width: 6),
                    // 접어두면 안이 안 보이므로 개수를 함께 보여준다.
                    PlainText(
                      '$count',
                      style: labelStyle.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (editMode) ...[
            _HeaderAction(
              icon: Icons.keyboard_arrow_up_rounded,
              tooltip: '위로',
              onPressed: index == 0
                  ? null
                  : () => reorderFavoriteGroups(ref, index, index - 1),
            ),
            _HeaderAction(
              icon: Icons.keyboard_arrow_down_rounded,
              tooltip: '아래로',
              onPressed: index == total - 1
                  ? null
                  : () => reorderFavoriteGroups(ref, index, index + 1),
            ),
            _HeaderAction(
              icon: Icons.drive_file_rename_outline,
              tooltip: '이름 변경',
              onPressed: () => _rename(context, ref),
            ),
            _HeaderAction(
              icon: Icons.delete_outline_rounded,
              tooltip: '그룹 삭제',
              // 마지막 남은 그룹은 지울 수 없다(게시판이 갈 곳이 없어진다).
              onPressed: total <= 1
                  ? null
                  : () => removeFavoriteGroup(ref, group.id),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _rename(BuildContext context, WidgetRef ref) async {
    final String? name = await _promptGroupName(
      context,
      title: '그룹 이름 변경',
      initial: group.name,
    );
    if (name == null || name.trim().isEmpty) return;
    renameFavoriteGroup(ref, group.id, name);
  }
}

class const _HeaderAction({
  required final IconData icon,
  required final String tooltip,
  required final VoidCallback? onPressed,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: tooltip,
    visualDensity: VisualDensity.compact,
    iconSize: 20,
    padding: const EdgeInsets.all(6),
    constraints: const BoxConstraints(),
    icon: Icon(icon),
    onPressed: onPressed,
  );
}

/// 등록한 게시판 한 줄. 평소엔 탭으로 진입하고, 편집 모드에선
/// 탭=그룹 이동 / 드래그=순서 변경 / X=삭제 로 동작한다.
class const _BoardTile({
  super.key,
  required final FavoriteData favorite,
  required final int index,
  required final bool editMode,
  required final bool showSite,
}) extends ConsumerWidget
    with MainState, MainEvent, FavoriteEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryColor = Theme.of(context).primaryColor;

    return Material(
      // ReorderableList 항목은 Material 조상을 상속받지 못해 ListTile 이 assert 됨.
      // 항목마다 투명 Material 을 둬 ListTile/잉크 효과가 동작하게 한다.
      type: MaterialType.transparency,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: favorite.icon.isEmpty
                ? null
                : _buildIconView(favorite.icon),
            title: PlainText(favorite.text, style: titleTextStyleState(ref)),
            // 그룹 이름이 곧 사이트면 중복이라 생략하고, 섞인 그룹에서만 밝힌다.
            subtitle: showSite
                ? PlainText(
                    favorite.siteType.title,
                    style: smallTextStyleState(ref),
                  )
                : null,
            trailing: editMode
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: '삭제',
                        icon: const Icon(Icons.close_rounded),
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
                  )
                : null,
            onTap: editMode
                ? () => _showGroupPicker(context, ref)
                : () => _openBoard(context, ref),
            contentPadding: const EdgeInsets.fromLTRB(16, 2, 8, 2),
          ),
          const PlainDividerWidget(),
        ],
      ),
    );
  }

  /// 리스트/파서는 전역 currentSiteType 을 따르므로, 다른 사이트 게시판이라도
  /// 먼저 사이트를 전환한 뒤 진입한다.
  void _openBoard(BuildContext context, WidgetRef ref) {
    changeSiteType(ref, favorite.siteType);
    context.push(Routes.list, extra: favorite.toMainItem());
  }

  Future<void> _showGroupPicker(BuildContext context, WidgetRef ref) =>
      showDialog<void>(
        context: context,
        builder: (_) => _GroupPickerDialog(favorite: favorite),
      );

  Widget _buildIconView(String url) => CircleAvatar(
    radius: 18,
    backgroundImage: CachedNetworkImageProvider(url),
  );
}

/// 게시판을 다른 그룹으로 옮기는 선택 다이얼로그.
class const _GroupPickerDialog({required final FavoriteData favorite})
    extends ConsumerWidget
    with FavoriteState, FavoriteEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<FavoriteGroup> groups =
        favoriteGroupsState(ref).asData?.value ?? const [];
    final theme = Theme.of(context);

    return SimpleDialog(
      title: Text('그룹 이동', style: theme.textTheme.headlineMedium),
      children: [
        for (final FavoriteGroup group in groups)
          SimpleDialogOption(
            onPressed: () {
              moveFavoriteToGroup(ref, favorite, group.id);
              Navigator.of(context).pop();
            },
            child: Row(
              children: [
                Icon(
                  group.id == favorite.group
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: theme.focusColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(group.name)),
              ],
            ),
          ),
      ],
    );
  }
}

/// 그룹 이름 입력(추가 · 이름 변경 공용). 취소하면 null 을 돌려준다.
Future<String?> _promptGroupName(
  BuildContext context, {
  required String title,
  String initial = '',
}) async {
  final TextEditingController controller = TextEditingController(text: initial);
  final String? result = await showDialog<String>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title, style: Theme.of(dialogContext).textTheme.headlineMedium),
      content: TextField(
        controller: controller,
        autofocus: true,
        textInputAction: TextInputAction.done,
        decoration: const InputDecoration(hintText: '그룹 이름'),
        onSubmitted: (value) => Navigator.of(dialogContext).pop(value),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('취소'),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(controller.text),
          child: const Text('확인'),
        ),
      ],
    ),
  );
  controller.dispose();
  return result;
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

class const _MainAppBar() extends ConsumerWidget
    with MainState, MainEvent, FavoriteEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleStyle = ref.watch(appbarTextStyleProvider);
    final bool editMode = editModeState(ref);

    return SliverAppBar(
      scrolledUnderElevation: 0,
      title: PlainText(editMode ? '편집' : '내 게시판', style: titleStyle),
      titleTextStyle: titleStyle,
      // titleSpacing: 0,
      // floating: true,
      pinned: true,
      centerTitle: true,
      toolbarHeight: kToolbarHeight,
      // floating 앱바의 toolbarOpacity 로 인한 PlainIcon 리빌드 차단.
      // (AppbarActionsIconTheme 주석 참고)
      actions: <Widget>[
        AppbarActionsIconTheme(
          children: editMode
              // 편집 모드: 그룹을 추가하거나 '완료' 로 빠져나간다.
              ? [
                  PlainIconButton(
                    onPressed: () => _addGroup(context, ref),
                    icon: const PlainIcon(Icons.create_new_folder_outlined),
                  ),
                  PlainIconButton(
                    onPressed: () => handleToggleEdit(ref),
                    icon: const PlainIcon(Icons.check),
                  ),
                ]
              : [
                  PlainIconButton(
                    onPressed: () => handleAddButton(ref, context),
                    icon: const PlainIcon(Icons.add),
                  ),
                  // 로그인은 사이트별로 필요하므로 게시판 추가 화면으로 옮겼다.
                  // 여기 남는 건 편집뿐이라 메뉴 대신 버튼으로 바로 노출한다.
                  PlainIconButton(
                    onPressed: () => handleToggleEdit(ref),
                    icon: const PlainIcon(Icons.tune_rounded),
                  ),
                ],
        ),
      ],
    );
  }

  Future<void> _addGroup(BuildContext context, WidgetRef ref) async {
    final String? name = await _promptGroupName(context, title: '그룹 추가');
    if (name == null || name.trim().isEmpty) return;
    addFavoriteGroup(ref, name);
  }
}
