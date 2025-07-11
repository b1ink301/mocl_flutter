import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/app_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/detail/providers/detail_providers.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/appbar_dual_text_widget.dart';

class DetailAppBar extends ConsumerWidget {
  const DetailAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => PlatformWidget(
    material: (context, _) => _buildMaterialAppBar(context, ref),
    cupertino: (context, _) {
      final String title = ref.watch(detailTitleNotifierProvider);
      final double height = ref.read(detailAppbarHeightProvider(title));
      return SliverPersistentHeader(
        delegate: _DetailCupertinoAppBar(title: title, height: height),
      );
    },
  );

  Widget _buildMaterialAppBar(BuildContext context, WidgetRef ref) {
    final String title = ref.watch(detailTitleNotifierProvider);
    final String smallTitle = ref.watch(detailSmallTitleProvider);
    final double height = ref.read(detailAppbarHeightProvider(title));
    return AppbarDualTextWidget(
      title: title,
      smallTitle: smallTitle,
      automaticallyImplyLeading: Platform.isMacOS,
      toolbarHeight: height,
      actions: [_buildPopupMenuButton(context, ref)],
    );
  }

  Widget _buildPopupMenuButton(BuildContext context, WidgetRef ref) =>
      PlatformPopupMenu(
        icon: Icon(
          size: 24,
          context.platformIcon(
            material: Icons.more_vert_rounded,
            cupertino: CupertinoIcons.ellipsis,
          ),
        ),
        options: [
          PopupMenuOption(
            label: '새로고침',
            onTap: (_) => ref.read(detailsNotifierProvider.notifier).refresh(),
          ),
          PopupMenuOption(
            label: '브라우저로 열기',
            onTap: (_) {
              final String url = ref.read(detailUrlProvider);
              ref.read(openBrowserByUrlProvider(url));
            },
          ),
          PopupMenuOption(
            label: '공유하기',
            onTap: (_) {
              final String url = ref.read(detailUrlProvider);
              ref.read(shareUrlProvider(url));
            },
          ),
          PopupMenuOption(label: '글자크기 변경', onTap: (_) {}),
        ],
      );
}

class _DetailCupertinoAppBar extends SliverPersistentHeaderDelegate {
  final String title;
  final double height;

  const _DetailCupertinoAppBar({required this.title, required this.height});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    color: CupertinoTheme.of(context).scaffoldBackgroundColor,
    child: Text(
      title,
      style: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    ),
  );

  @override
  double get maxExtent => height; // 3줄 높이에 맞게 조정

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
