import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/di/app_provider.dart';
import 'package:mocl_flutter/features/app_shell/presentation/pages/main/providers/main_providers.dart';
import 'package:mocl_flutter/features/app_shell/presentation/routes/mocl_routes.dart';
import 'package:mocl_flutter/core/presentation/widgets/app_version_widget.dart';

class DrawerWidget extends ConsumerWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => SafeArea(
    left: false,
    right: false,
    child: Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          const _DrawerHeader(),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: SiteType.values
                  .map(
                    (SiteType siteType) => _DrawerSiteItem(
                      siteType: siteType,
                      onTap: () => _changeSiteType(
                        context,
                        siteType,
                        () => ref
                            .read(currentSiteTypeNotifierProvider.notifier)
                            .changeSiteType(siteType),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const AppVersionWidget(),
        ],
      ),
    ),
  );

  void _changeSiteType(
    BuildContext context,
    SiteType siteType,
    VoidCallback onChangeSiteType,
  ) {
    context.pop();

    if (siteType == SiteType.settings) {
      context.push(Routes.settings);
    } else {
      onChangeSiteType();
    }
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader();

  @override
  Widget build(BuildContext context) => Container(
    height: 220,
    color: Theme.of(context).primaryColor,
    child: Center(
      child: ClipOval(
        child: Image.asset('assets/icon.png', width: 80, height: 80),
      ),
    ),
  );
}

class _DrawerSiteItem extends ConsumerWidget {
  const _DrawerSiteItem({required this.siteType, required this.onTap});

  final SiteType siteType;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
    children: [
      ListTile(
        title: Text(siteType.title),
        titleTextStyle: MoclTextStyles.of(context).titleTextStyle,
        onTap: onTap,
        trailing: ref.watch(isCurrentSiteTypeProvider(siteType))
            ? Icon(Icons.check_outlined, color: Theme.of(context).focusColor)
            : null,
      ),
      const Divider(height: 1, thickness: 1, indent: 12, endIndent: 8),
    ],
  );
}
