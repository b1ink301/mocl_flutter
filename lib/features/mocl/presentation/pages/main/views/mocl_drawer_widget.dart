import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
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
            ),
            ListTile(
              title: Text(SiteType.damoang.title),
              titleTextStyle: Theme.of(context).textTheme.bodyMedium,
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
              title: Text(SiteType.clien.title),
              titleTextStyle: Theme.of(context).textTheme.bodyMedium,
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
              titleTextStyle: Theme.of(context).textTheme.bodyMedium,
              onTap: () {
                // Get.toNamed(Routes.SETTING);

                Get.snackbar(
                  'Mocl',
                  '미구현',
                  // colorText: Colors.white,
                  // backgroundColor: Colors.red,
                  // snackPosition: SnackPosition.TOP,
                );

                Navigator.of(context).pop();
              },
            ),
            const Spacer(),
            ListTile(
              title: const Text(''),
              titleTextStyle: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      );
}
