import 'package:flutter/material.dart';

import '../../../../domain/entities/mocl_site_type.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key, required this.onChangeSite});

  final Future<void> Function(SiteType) onChangeSite;

  @override
  Widget build(BuildContext context) => Drawer(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            Container(
              height: 200,
              color: Theme.of(context).primaryColor,
            ),
            ListTile(
              title: const Text('다모앙'),
              onTap: () async {
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
                await onChangeSite(SiteType.damoang);
              },
            ),
            const Divider(
              height: 1,
              thickness: 1,
              indent: 12,
              endIndent: 8,
            ),
            ListTile(
              title: const Text('클리앙'),
              onTap: () async {
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
                await onChangeSite(SiteType.clien);
              },
            ),
            const Divider(
              height: 1,
              thickness: 1,
              indent: 12,
              endIndent: 8,
            ),
            ListTile(
              title: const Text('설정'),
              onTap: () {
                // Get.toNamed(Routes.SETTING);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
}
