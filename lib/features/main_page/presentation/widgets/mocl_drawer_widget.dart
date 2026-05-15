import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/config/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/presentation/widgets/app_version_widget.dart';

import '../../../../core/presentation/widgets/plain_divider_widget.dart';
import '../../../../core/presentation/widgets/plain_icon.dart';
import '../../../../core/presentation/widgets/plain_text.dart';
import '../state/main_event_mixin.dart';
import '../state/main_state_mixin.dart';

class DrawerWidget extends ConsumerWidget with MainEvent {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => SafeArea(
    bottom: false,
    child: Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          const _DrawerHeader(),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: SiteType.values.length,
              itemBuilder: (context, index) {
                final siteType = SiteType.values[index];
                return _DrawerSiteItem(
                  siteType: siteType,
                  onTap: () => _handleSiteTap(context, ref, siteType),
                );
              },
            ),
          ),
          const SafeArea(child: AppVersionWidget()),
        ],
      ),
    ),
  );

  void _handleSiteTap(BuildContext context, WidgetRef ref, SiteType siteType) {
    context.pop();

    if (siteType == SiteType.settings) {
      context.push(Routes.settings);
    } else {
      changeSiteType(ref, siteType);
    }
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader();

  @override
  Widget build(BuildContext context) => Container(
    color: Theme.of(context).primaryColor,
    height: 220,
    child: Center(
      child: ClipOval(
        child: Image.asset('assets/icon.png', width: 80, height: 80),
      ),
    ),
  );
}

class _DrawerSiteItem extends ConsumerWidget with MainState {
  const _DrawerSiteItem({required this.siteType, required this.onTap});

  final SiteType siteType;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = isSiteType(ref, siteType);

    return Column(
      children: [
        ListTile(
          title: PlainText(siteType.title, style: titleTextStyleState(ref)),
          onTap: onTap,
          trailing: isSelected
              ? PlainIcon(
                  Icons.check_outlined,
                  color: Theme.of(context).focusColor,
                )
              : null,
        ),
        const PlainDividerWidget(indent: 12, endIndent: 8),
      ],
    );
  }
}
