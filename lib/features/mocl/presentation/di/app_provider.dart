import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/domain/usecases/get_site_type.dart';
import 'package:mocl_flutter/core/domain/usecases/set_site_type.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/use_case_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/detail/mocl_detail_page.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/detail/photo_view_dialog.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/mocl_list_page.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/login/login_page.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/add_dialog/add_list_dialog.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/mocl_main_page.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/settings/settings_page.dart';
import 'package:mocl_flutter/features/mocl/presentation/routes/mocl_routes.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/dialog_page.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/nick_image_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'package:url_launcher/url_launcher.dart';

part 'app_provider.g.dart';

@Riverpod(keepAlive: true)
class CurrentSiteTypeNotifier extends _$CurrentSiteTypeNotifier {
  @override
  SiteType build() {
    final GetSiteType getSiteType = ref.read(getSiteTypeProvider);
    return getSiteType(NoParams());
  }

  void changeSiteType(SiteType siteType) {
    if (state != siteType) {
      final SetSiteType setSiteType = ref.read(setSiteTypeProvider);
      setSiteType(siteType);
      state = siteType;
    }
  }
}

@Riverpod(keepAlive: true)
class ReadableStateNotifier extends _$ReadableStateNotifier {
  @override
  int build() => -1;

  void update(int newId) {
    if (state != newId) {
      state = newId;
    }
  }

  void clear() => state = -1;
}

@Riverpod(keepAlive: true)
Future<String> getAppVersion(Ref ref) async {
  final PackageInfo info = await PackageInfo.fromPlatform();
  final String version = '${info.version}-${info.buildNumber}';
  return version;
}

@riverpod
Future<void> clearData(Ref ref) async {
  await NickImageWidget.clearCache();
  await InAppWebViewController.clearAllCache();

  // CookieManager.instance().deleteAllCookies();
  await Future.delayed(Duration(milliseconds: 300));
}

@riverpod
void showToast(Ref ref, String message, BuildContext context) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 2,
    backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) => GoRouter(
  initialLocation: Routes.main,
  routes: <RouteBase>[
    GoRoute(
      path: Routes.main,
      pageBuilder: (BuildContext context, GoRouterState state) => SwipeablePage(
        builder: (BuildContext context) {
          final width = MediaQuery.of(context).size.width;
          return MainPage.init(context, width);
        },
      ),
      routes: [
        GoRoute(
          path: Routes.setMainDlg,
          pageBuilder: (BuildContext context, GoRouterState state) =>
              CupertinoModalPopupPage(
                builder: (BuildContext context) => AddListDialog.init(context),
              ),
        ),
      ],
    ),
    GoRoute(
      path: Routes.list,
      pageBuilder: (BuildContext context, GoRouterState state) => SwipeablePage(
        builder: (BuildContext context) {
          final MainItem item = GoRouterState.of(context).extra as MainItem;
          return MoclListPage.init(context, item);
        },
      ),
    ),
    GoRoute(
      path: Routes.detail,
      pageBuilder: (BuildContext context, GoRouterState state) => SwipeablePage(
        builder: (BuildContext context) {
          final ListItem item = GoRouterState.of(context).extra as ListItem;
          return DetailPage.init(context, item);
        },
      ),
      routes: [
        GoRoute(
          path: Routes.viewPhotoDlg,
          pageBuilder: (BuildContext context, GoRouterState state) =>
              CupertinoModalPopupPage(
                builder: (BuildContext context) {
                  final url = GoRouterState.of(context).extra as String;
                  return PhotoViewDialog(
                    imageProvider: NetworkImage(url),
                    filterQuality: FilterQuality.high,
                  );
                },
              ),
        ),
      ],
    ),
    GoRoute(
      path: Routes.settings,
      pageBuilder: (BuildContext context, GoRouterState state) => SwipeablePage(
        builder: (BuildContext context) => SettingsPage.init(context),
      ),
    ),
    GoRoute(
      path: Routes.login,
      builder: (BuildContext context, GoRouterState state) => const LoginPage(),
    ),
  ],
);

@riverpod
Future<bool> openBrowserByUrl(Ref ref, String url) async {
  final Uri uri = Uri.parse(url);
  return await launchUrl(uri);
}

@riverpod
Future<bool> shareUrl(Ref ref, String url) async {
  final Uri uri = Uri.parse(url);
  final ShareParams params = ShareParams(uri: uri);
  final ShareResult result = await SharePlus.instance.share(params);
  return result.status == ShareResultStatus.success;
}

@Riverpod(dependencies: [_isImageUrl])
Future<bool> openUrl(Ref ref, BuildContext context, String url) async {
  final Uri uri = Uri.parse(url);
  final String? last = uri.pathSegments.lastOrNull;
  if (last != null && ref.read(_isImageUrlProvider(last))) {
    context.push(Routes.viewPhotoDlgFull, extra: url);
    return true;
  }
  return await ref.read(openBrowserByUrlProvider(url).future);
}

@riverpod
bool _isImageUrl(Ref ref, String url) {
  final List<String> imageExtensions = [
    '.jpg',
    '.jpeg',
    '.png',
    '.gif',
    '.bmp',
    '.webp',
    '.tiff',
  ];
  return imageExtensions.any((ext) => url.toLowerCase().endsWith(ext));
}

@riverpod
TextStyle appbarTextStyle(Ref ref) =>
    throw UnimplementedError('appbarTextStyle');

@Riverpod(keepAlive: true)
double screenWidth(Ref ref) => throw UnimplementedError('screenWidth');
