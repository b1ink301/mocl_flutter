import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/app_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/login/login_view.dart';

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
                flexibleSpace: Container(color: backgroundColor),
                backgroundColor: backgroundColor,
                titleSpacing: 0,
                centerTitle: false,
                toolbarHeight: 64,
              ),
          cupertino: (_, _) => CupertinoNavigationBarData(
                title: PlatformText('로그인'),
                previousPageTitle: siteType.title,
                backgroundColor: backgroundColor,
              )),
      body: const SafeArea(
        left: false,
        right: false,
        child: LoginView(),
      ),
    );
  }
}
