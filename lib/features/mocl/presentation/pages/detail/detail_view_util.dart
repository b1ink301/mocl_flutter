import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/features/mocl/presentation/routes/mocl_routes.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailViewUtil {
  static Future<bool> openBrowserByUrl(String url) async {
    final Uri uri = Uri.parse(url);
    return await launchUrl(uri);
  }

  static Future<void> shareUrl(String url) async {
    final Uri uri = Uri.parse(url);
    await Share.shareUri(uri);
  }

  static FutureOr<bool> openUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    final last = uri.pathSegments.lastOrNull;
    debugPrint('_onTapUrl url=$url, last=$last');

    if (last != null && _isImageUrl(last)) {
      context.push(Routes.viewPhotoDlgFull, extra: url);
    } else {
      openBrowserByUrl(url);
    }
    return Future.value(true);
  }

  static bool _isImageUrl(String url) {
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
}
