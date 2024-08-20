import 'package:flutter/material.dart';

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
  })  : _smallTitle = smallTitle,
        _title = title,
        _toolbarHeight = toolbarHeight;

  Widget _buildTitle(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MessageWidget(
            message: _smallTitle,
            textStyle:
                Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 11),
          ),
          const SizedBox(height: 2),
          MessageWidget(
            textStyle: Theme.of(context).textTheme.labelMedium,
            message: _title,
          ),
        ],
      );

  Widget _buildAppbar(BuildContext context) => SliverAppBar(
        title: _buildTitle(context),
        flexibleSpace:
            Container(color: Theme.of(context).appBarTheme.backgroundColor),
        titleSpacing:
            automaticallyImplyLeading ? 0 : NavigationToolbar.kMiddleSpacing,
        automaticallyImplyLeading: automaticallyImplyLeading,
        centerTitle: false,
        floating: true,
        pinned: false,
        toolbarHeight: _toolbarHeight,
        actions: actions,
      );
// 448 , 368
  @override
  Widget build(BuildContext context) => _buildAppbar(context);
}
