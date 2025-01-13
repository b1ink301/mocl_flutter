import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/app_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/detail/providers/detail_providers.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/appbar_dual_text_widget.dart';

class DetailAppBar extends ConsumerWidget {
  const DetailAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String title = ref.watch(detailTitleProvider);
    final String smallTitle = ref.watch(detailSmallTitleProvider);
    final double height = ref.read(detailAppbarHeightProvider(title));

    return AppbarDualTextWidget(
      title: title,
      smallTitle: smallTitle,
      automaticallyImplyLeading: Platform.isMacOS,
      toolbarHeight: height,
      actions: _buildPopupMenuButton(context, ref),
    );
  }

  List<Widget> _buildPopupMenuButton(BuildContext context, WidgetRef ref) => [
        PopupMenuButton<int>(
          icon: const Icon(Icons.more_vert),
          onSelected: (int value) {
            switch (value) {
              case 0:
                ref.read(detailsNotifierProvider.notifier).refresh();
                break;
              case 1:
                final String url = ref.read(detailUrlProvider);
                ref.read(openBrowserByUrlProvider(url));
                break;
              case 2:
                final String url = ref.read(detailUrlProvider);
                ref.read(shareUrlProvider(url));
                break;
            }
          },
          itemBuilder: (BuildContext context) {
            final textStyle = Theme.of(context).textTheme.headlineSmall;
            return [
              PopupMenuItem(
                value: 0,
                child: Text('새로고침', style: textStyle),
              ),
              PopupMenuItem(
                value: 1,
                child: Text('브라우저로 열기', style: textStyle),
              ),
              PopupMenuItem(
                value: 2,
                enabled: Platform.isAndroid || Platform.isIOS,
                child: Text('공유하기', style: textStyle),
              ),
            ];
          },
        )
      ];
}
