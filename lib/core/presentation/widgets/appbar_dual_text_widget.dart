import 'package:flutter/material.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';

import 'message_widget.dart';

class AppbarDualTextWidget extends StatelessWidget {
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

  Widget _buildTitle(BuildContext context) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MessageWidget(
            message: _smallTitle,
            textStyle: Theme
                .of(context)
                .textTheme
                .labelSmall,
          ),
          const SizedBox(height: 4),
          MessageWidget(
            textStyle: AppTextStyles
                .of(context)
                .titleTextStyle
                .copyWith(color: Colors.white),
            message: _title,
          ),
        ],
      );

  Widget _buildAppbar(BuildContext context) =>
      SliverAppBar(
        title: _buildTitle(context),
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
  Widget build(BuildContext context) => _buildAppbar(context);
}
