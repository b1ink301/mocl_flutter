import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'login_view.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    appBar: AppBar(
      title: Text('로그인', style: Theme.of(context).textTheme.labelMedium),
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      titleSpacing: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      toolbarHeight: 64,
    ),
    body: const SafeArea(child: LoginView()),
  );
}
