import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/di/app_provider.dart';
import 'package:mocl_flutter/features/app_shell/presentation/pages/login/login_view.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = Theme.of(context).appBarTheme.backgroundColor;
    final style = Theme.of(context).textTheme.labelMedium;
    final siteType = ref.watch(currentSiteTypeNotifierProvider);
    return PlatformScaffold(
      appBar: PlatformAppBar(
        material: (_, _) => MaterialAppBarData(
          title: PlatformText('로그인', style: style),
          backgroundColor: backgroundColor,
          titleSpacing: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          toolbarHeight: 64,
        ),
        cupertino: (_, _) => CupertinoNavigationBarData(
          title: PlatformText('로그인'),
          previousPageTitle: siteType.title,
          backgroundColor: backgroundColor,
        ),
      ),
      body: const SafeArea(child: LoginView()),
    );
  }
}
