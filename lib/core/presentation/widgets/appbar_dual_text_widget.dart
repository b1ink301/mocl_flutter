import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';

import 'message_widget.dart';

class AppbarDualTextWidget extends ConsumerWidget {
  final String _smallTitle;
  final String _title;
  final double _toolbarHeight;
  final bool automaticallyImplyLeading;
  final List<Widget>? actions;

  const AppbarDualTextWidget({
    super.key,
    required String smallTitle,
    required String title,
    double toolbarHeight = 64,
    this.automaticallyImplyLeading = false,
    this.actions,
  })
      : _smallTitle = smallTitle,
        _title = title,
        _toolbarHeight = toolbarHeight;

  Widget _buildTitle(BuildContext context, WidgetRef ref) {
    final delta = ref.watch(fontSizeDeltaProvider);
    final baseStyle = AppTextStyles.of(context).titleTextStyle;
    final adjustedStyle = baseStyle.copyWith(
      color: Colors.white,
      fontSize: baseStyle.fontSize! + delta,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MessageWidget(
          message: _smallTitle,
          textStyle: Theme.of(context).textTheme.labelSmall,
        ),
        const SizedBox(height: 4),
        MessageWidget(
          textStyle: adjustedStyle,
          message: _title,
        ),
      ],
    );
  }

  Widget _buildAppbar(BuildContext context, WidgetRef ref) =>
      SliverAppBar(
        title: _buildTitle(context, ref),
        scrolledUnderElevation: 0,
        titleSpacing: automaticallyImplyLeading
            ? 0
            : NavigationToolbar.kMiddleSpacing,
        automaticallyImplyLeading: automaticallyImplyLeading,
        centerTitle: false,
        floating: true,
        pinned: false,
        toolbarHeight: _toolbarHeight,
        actions: actions,
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      _buildAppbar(context, ref);
}
