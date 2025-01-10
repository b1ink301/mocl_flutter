import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_site_type.dart';
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

final localeCodeProvider = StateProvider<String>((ref) => 'ko');

@Riverpod(keepAlive: true)
class CurrentSiteTypeNotifier extends _$CurrentSiteTypeNotifier {
  @override
  SiteType build() {
    final GetSiteType getSiteType = ref.read(getSiteTypeProvider);
    return getSiteType(NoParams());
  }

  void changeSiteType(SiteType siteType) {
    if (state != siteType) {
      final setSiteType = ref.read(setSiteTypeProvider);
      setSiteType(siteType);
      state = siteType;
    }
  }
}

const double kMoreIconSize = 48.0; // more 아이콘의 크기
const double kHorizontalPadding = 16.0; // 좌우 패딩
const double kMinTextHeight = 30.0; // 최소 텍스트 높이
const double kExtraVerticalSpace = 36.0; // 추가 수직 공간

@riverpod
double appbarHeight(
  ref,
  String text,
  TextStyle style,
  double screenWidth,
) {
  final availableWidth = screenWidth -
      kMoreIconSize // more 아이콘 크기
      -
      (kHorizontalPadding * 2); // 좌우 패딩

  final textPainter = TextPainter(
    text: TextSpan(
      text: text,
      style: style,
    ),
    maxLines: 3,
    textDirection: TextDirection.ltr,
  )..layout(
      minWidth: 0,
      maxWidth: availableWidth,
    );

  // 최소 높이와 비교하여 더 큰 값 반환
  return max(kMinTextHeight, textPainter.height) + kExtraVerticalSpace;
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
  final info = await PackageInfo.fromPlatform();
  final version = 'v${info.version}-${info.buildNumber}';
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

@riverpod
GoRouter appRouter(Ref ref) => GoRouter(
      initialLocation: Routes.main,
      routes: <RouteBase>[
        GoRoute(
            path: Routes.main,
            pageBuilder: (BuildContext context, GoRouterState state) =>
                SwipeablePage(builder: (context) => MainPage.init(context)),
            routes: [
              GoRoute(
                  path: Routes.setMainDlg,
                  pageBuilder: (BuildContext context, GoRouterState state) =>
                      CupertinoModalPopupPage(
                        builder: (BuildContext context) =>
                            AddListDialog.init(context),
                      )),
            ]),
        GoRoute(
          path: Routes.list,
          pageBuilder: (BuildContext context, GoRouterState state) =>
              SwipeablePage(builder: (context) {
            final item = GoRouterState.of(context).extra as MainItem;
            return MoclListPage.init(context, item);
          }),
        ),
        GoRoute(
            path: Routes.detail,
            pageBuilder: (BuildContext context, GoRouterState state) =>
                SwipeablePage(
                  builder: (context) {
                    final item = GoRouterState.of(context).extra as ListItem;
                    return DetailPage.withRiverpod(context, item);
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
                      )),
            ]),
        GoRoute(
          path: Routes.settings,
          pageBuilder: (BuildContext context, GoRouterState state) =>
              SwipeablePage(
                  builder: (context) => SettingsPage.withBloc(context)),
        ),
        GoRoute(
          path: Routes.login,
          builder: (BuildContext context, GoRouterState state) =>
              const LoginPage(),
        )
      ],
    );

@riverpod
Future<bool> openBrowserByUrl(ref, String url) async {
  final Uri uri = Uri.parse(url);
  return await launchUrl(uri);
}

@riverpod
Future<bool> shareUrl(ref, String url) async {
  final Uri uri = Uri.parse(url);
  final result = await Share.shareUri(uri);
  return result.status == ShareResultStatus.success;
}

@Riverpod(dependencies: [_isImageUrl])
void openUrl(ref, BuildContext context, String url) {
  final uri = Uri.parse(url);
  final last = uri.pathSegments.lastOrNull;
  final isImageUrl = ref.read(_isImageUrlProvider);

  if (last != null && isImageUrl(last)) {
    context.push(Routes.viewPhotoDlgFull, extra: url);
  } else {
    ref.read(openBrowserByUrlProvider)(url);
  }
}

@riverpod
bool _isImageUrl(ref, String url) {
  final imageExtensions = [
    '.jpg',
    '.jpeg',
    '.png',
    '.gif',
    '.bmp',
    '.webp',
    '.tiff'
  ];
  return imageExtensions.any((ext) => url.toLowerCase().endsWith(ext));
}
