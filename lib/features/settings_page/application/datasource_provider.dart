import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mocl_flutter/core/presentation/widgets/nick_image_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'datasource_provider.g.dart';

@riverpod
SharedPreferences sharedPreferences(Ref ref) =>
    throw UnimplementedError('sharedPreferences');

@Riverpod(keepAlive: true)
Future<String> getAppVersion(Ref ref) async {
  final PackageInfo info = await PackageInfo.fromPlatform();
  final String version = 'v${info.version}-${info.buildNumber}';
  return version;
}

@riverpod
Future<void> clearData(Ref ref) async {
  await NickImageWidget.clearCache();
  await InAppWebViewController.clearAllCache();

  // CookieManager.instance().deleteAllCookies();
  await Future.delayed(Duration(milliseconds: 300));
}
