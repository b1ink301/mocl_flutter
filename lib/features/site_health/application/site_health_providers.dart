import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mocl_flutter/features/remote_config/data/remote_config_fetcher.dart'
    show moclApiBaseUrl;
import 'package:mocl_flutter/features/settings_page/application/datasource_provider.dart';
import 'package:mocl_flutter/features/site_health/data/site_health_reporter.dart';
import 'package:mocl_flutter/features/site_health/data/site_report_client.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'site_health_providers.g.dart';

@Riverpod(keepAlive: true)
SiteReportClient siteReportClient(Ref ref) {
  final Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
    ),
  );
  ref.onDispose(dio.close);
  return SiteReportClient(dio, moclApiBaseUrl);
}

/// "문제 알리기" 를 보일지(서버 주소가 있는 빌드만).
@Riverpod(keepAlive: true)
bool siteReportsAvailable(Ref ref) =>
    ref.watch(siteReportClientProvider).available;

@Riverpod(keepAlive: true)
SiteHealthReporter siteHealthReporter(Ref ref) => SiteHealthReporter(
  prefs: ref.watch(sharedPreferencesProvider),
  client: ref.watch(siteReportClientProvider),
  appVersion: reportAppVersion,
  platform: reportPlatform,
  enabled: kReleaseMode,
);

String? _version;

/// 신고에 담는 앱 버전(`1.6.4+412`). 받은 값만 기억한다.
Future<String> reportAppVersion() async {
  if (_version case final String v) return v;
  final PackageInfo info = await PackageInfo.fromPlatform();
  return _version = '${info.version}+${info.buildNumber}';
}

/// 신고에 담는 플랫폼(`SiteReport.platforms`).
String get reportPlatform => Platform.isAndroid
    ? 'android'
    : Platform.isIOS
    ? 'ios'
    : Platform.isMacOS
    ? 'macos'
    : 'other';
