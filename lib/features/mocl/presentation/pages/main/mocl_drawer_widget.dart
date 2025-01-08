import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/app_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/providers/main_providers.dart';
import 'package:mocl_flutter/features/mocl/presentation/routes/mocl_routes.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/app_version_widget.dart';

class DrawerWidget extends ConsumerWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => SafeArea(
        left: false,
        right: false,
        bottom: false,
        child: Drawer(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: [
              const _DrawerHeader(),
              ...SiteType.values.map(
                (SiteType siteType) => _DrawerSiteItem(
                  siteType: siteType,
                  onTap: () => _changeSiteType(context, siteType, ref),
                ),
              ),
              const Spacer(),
              const AppVersionWidget(),
              SizedBox(height: MediaQuery.of(context).padding.bottom)
            ],
          ),
        ),
      );

  void _changeSiteType(BuildContext context, SiteType siteType, WidgetRef ref) {
    if (siteType == SiteType.settings) {
      context.push(Routes.settings);
    } else {
      ref
          .read(currentSiteTypeNotifierProvider.notifier)
          .changeSiteType(siteType);
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
            child: Image.asset(
              'assets/icon.png',
              width: 80,
              height: 80,
            ),
          ),
        ),
      );
}

class _DrawerSiteItem extends ConsumerWidget {
  const _DrawerSiteItem({
    required this.siteType,
    required this.onTap,
  });

  final SiteType siteType;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
        children: [
          ListTile(
            title: Text(siteType.title),
            titleTextStyle: Theme.of(context).textTheme.bodyMedium,
            onTap: onTap,
            trailing: ref.watch(isCurrentSiteTypeProvider(siteType))
                ? Icon(
                    Icons.check_outlined,
                    color: Theme.of(context).indicatorColor,
                  )
                : null,
          ),
          const Divider(
            height: 1,
            thickness: 1,
            indent: 12,
            endIndent: 8,
          ),
        ],
      );
}
