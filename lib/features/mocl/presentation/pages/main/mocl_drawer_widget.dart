import 'package:flutter/material.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key, required this.onChangeSite});

  final void Function(SiteType) onChangeSite;

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  PackageInfo? _packageInfo;

  @override
  void initState() {
    _initPackageInfo();
    super.initState();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
              widget.onChangeSite(SiteType.damoang);
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
              widget.onChangeSite(SiteType.clien);
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

              Navigator.of(context).pop();
            },
          ),
          const Spacer(),

          ListTile(
            title: Text('v${_packageInfo?.version} + ${_packageInfo?.buildNumber}'),
            titleTextStyle: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
