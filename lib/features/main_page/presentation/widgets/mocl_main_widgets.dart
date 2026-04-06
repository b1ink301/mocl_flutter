part of '../mocl_main_view.dart';

class _MainBody extends ConsumerWidget with MainState, MainEvent {
  const _MainBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    listenNotLoginFailure(ref, context);
    return mainState(ref).when(
      data: (data) => SliverPadding(
        padding: .only(bottom: MediaQuery.of(context).padding.bottom),
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
    child: Center(child: Text('항목이 없습니다.\n항목을 추가해 주세요!', style: textStyle)),
  );

  Widget _buildListItem(
    BuildContext context,
    MainItem item,
    TextStyle? textStyle,
  ) => ListTile(
    key: ValueKey(item.board),
    leading: item.icon.isEmpty ? null : _buildIconView(item.icon),
    title: Text(item.text, style: textStyle),
    onTap: () => context.push(Routes.list, extra: item),
    contentPadding: const .fromLTRB(16, 4, 8, 4),
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
    padding: const .all(12.0),
    sliver: SliverToBoxAdapter(
      child: Text(
        message,
        style: TextStyle(fontSize: 16, color: Theme.of(context).focusColor),
      ),
    ),
  );
}

class _MainAppBar extends ConsumerWidget with MainState, MainEvent {
  const _MainAppBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final delta = ref.watch(fontSizeDeltaProvider);
    final baseStyle = AppTextStyles.of(context).titleTextStyle;
    return SliverAppBar(
      scrolledUnderElevation: 0,
      title: Text(titleState(ref)),
      titleTextStyle: baseStyle.copyWith(
        color: Colors.white,
        fontSize: baseStyle.fontSize! + delta,
      ),
      titleSpacing: 0,
      floating: true,
      toolbarHeight: 62,
      actions: [
        if (showAddButtonState(ref))
          IconButton(
            onPressed: () => handleAddButton(ref, context),
            icon: const Icon(Icons.add),
          ),
        AdaptivePopupMenu(
          options: [
            AdaptiveMenuOption(
              label: '로그인',
              onTap: () => handleLogin(ref, context),
            ),
          ],
          icon: Icon(
            size: 24,
            isCupertino() ? CupertinoIcons.ellipsis : Icons.more_vert_rounded,
          ),
        ),
      ],
    );
  }
}
