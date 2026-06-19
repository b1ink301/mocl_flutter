import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'login_view.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme.labelMedium;
    final backgroundColor = theme.appBarTheme.backgroundColor;
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인', style: style),
        backgroundColor: backgroundColor,
        titleSpacing: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        toolbarHeight: 64,
        actions: [
          // 사이트마다 로그인 후 이동 페이지가 달라 자동 감지가 어려우므로,
          // 로그인을 마친 뒤 직접 '완료'를 눌러 확정한다(쿠키는 이미 저장됨).
          TextButton(
            onPressed: () => context.pop(true),
            child: Text('완료', style: style),
          ),
        ],
      ),
      body: const SafeArea(child: LoginView()),
    );
  }
}
