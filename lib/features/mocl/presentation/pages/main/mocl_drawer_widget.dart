import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/app_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/loading_widget.dart';

class DrawerWidget extends ConsumerWidget {
  const DrawerWidget({super.key, required this.onChangeSite});

  final void Function(SiteType) onChangeSite;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      left: false,
      right: false,
      bottom: false,
      child: Drawer(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            Container(
              // padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
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
            ...SiteType.values.map((siteType) => Column(
                  children: [
                    ListTile(
                      title: Text(siteType.title),
                      titleTextStyle: Theme.of(context).textTheme.bodyMedium,
                      onTap: () {
                        if (context.mounted) {
                          Navigator.of(context).pop();
                          onChangeSite(siteType);
                        }
                      },
                      trailing: ref.watch(currentSiteTypeProvider) == siteType
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
                )),
            const Spacer(),
            ref.watch(getAppVersionProvider).maybeWhen(
                data: (version) => version.fold(
                      (failure) => SizedBox.shrink(),
                      (version) => ListTile(
                        title: Text(version, textAlign: TextAlign.center),
                        titleTextStyle: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                orElse: () => const LoadingWidget()),
            SizedBox(height: MediaQuery.of(context).padding.bottom)
          ],
        ),
      ),
    );
  }
}
