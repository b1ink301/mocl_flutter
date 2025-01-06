import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/app_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/detail/providers/detail_view_model.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/detail/detail_view_util.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/appbar_dual_text_widget.dart';

class DetailAppBar extends ConsumerWidget {
  const DetailAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyle = Theme.of(context).textTheme.labelMedium!;
    final textWidth = MediaQuery.of(context).size.width;
    final viewModel = ref.read(detailViewModelProvider.notifier);
    final height =
        ref.read(appbarHeightProvider(viewModel.title, textStyle, textWidth));

    return AppbarDualTextWidget(
      title: viewModel.title,
      smallTitle: viewModel.smallTitle,
      automaticallyImplyLeading: Platform.isMacOS,
      toolbarHeight: height,
      actions: _buildPopupMenuButton(context, viewModel),
    );
  }

  List<Widget> _buildPopupMenuButton(
          BuildContext context, DetailViewModel viewModel) =>
      [
        PopupMenuButton<int>(
          icon: const Icon(Icons.more_vert),
          onSelected: (int value) {
            switch (value) {
              case 0:
                viewModel.refresh();
                break;
              case 1:
                final url = viewModel.itemUrl;
                DetailViewUtil.openBrowserByUrl(url);
                break;
              case 2:
                final url = viewModel.itemUrl;
                DetailViewUtil.shareUrl(url);
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
