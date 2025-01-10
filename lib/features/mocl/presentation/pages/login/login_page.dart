import 'package:flutter/material.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/login/login_view.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/message_widget.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: _buildAppBar(context),
        body: const SafeArea(
          left: false,
          right: false,
          child: LoginView(),
        ),
      );

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
  ) {
    final backgroundColor = Theme.of(context).appBarTheme.backgroundColor;
    return AppBar(
      title: MessageWidget(
        message: '로그인',
        textStyle: Theme.of(context).textTheme.labelMedium,
      ),
      flexibleSpace: Container(color: backgroundColor),
      backgroundColor: backgroundColor,
      titleSpacing: 0,
      centerTitle: false,
      toolbarHeight: 64,
    );
  }
}
