import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'message_widget.dart';

class AppbarDualTextWidget extends StatelessWidget {
  final RxString _smallTitle;
  final RxString _title;
  final RxDouble _toolbarHeight;
  final bool automaticallyImplyLeading;
  final List<Widget>? actions;
  final bool hasObx;

  AppbarDualTextWidget({
    super.key,
    required RxString smallTitle,
    required RxString title,
    RxDouble? toolbarHeight,
    this.automaticallyImplyLeading = false,
    this.actions,
    this.hasObx = true,
  })
      : _smallTitle = smallTitle,
        _title = title,
        _toolbarHeight = toolbarHeight ?? kToolbarHeight.obs;

  Widget _buildTitle(BuildContext context) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MessageWidget(
            message: _smallTitle.value,
            textStyle:
            Theme
                .of(context)
                .textTheme
                .labelMedium
                ?.copyWith(fontSize: 11),
          ),
          const SizedBox(height: 2),
          MessageWidget(
            textStyle: Theme
                .of(context)
                .textTheme
                .labelMedium,
            message: _title.value,
          ),
        ],
      );

  Widget _buildAppbar(BuildContext context) =>
      SliverAppBar(
        title: _buildTitle(context),
        flexibleSpace:
        Container(color: Theme
            .of(context)
            .appBarTheme
            .backgroundColor),
        automaticallyImplyLeading: automaticallyImplyLeading,
        centerTitle: false,
        floating: true,
        pinned: false,
        toolbarHeight: _toolbarHeight.value,
        actions: actions,
      );

  @override
  Widget build(BuildContext context) =>
      hasObx ? Obx(() => _buildAppbar(context)) : _buildAppbar(context);
}