import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/config/routes/mocl_app_pages.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

extension ColorFromSring on String {
  Color toColor() {
    if (startsWith('#')) {
      return Color(int.parse(substring(1, 7), radix: 16) + 0xFF000000);
    } else {
      return Color(int.parse(this, radix: 16) + 0xFF000000);
    }
  }
}

extension ColorExtension on Color {
  String get stringHexColor {
    final String red = (r * 255).toInt().toRadixString(16).padLeft(2, '0');
    final String green = (g * 255).toInt().toRadixString(16).padLeft(2, '0');
    final String blue = (b * 255).toInt().toRadixString(16).padLeft(2, '0');
    // final alpha = (color.a * 255).toInt().toRadixString(16).padLeft(2, '0');
    return '#$red$green$blue'.toUpperCase();
  }
}

extension StringExtension on String {
  Future<bool> openBrowser() async {
    final Uri uri = Uri.parse(this);
    return await launchUrl(uri);
  }

  Future<bool> shareUrl() async {
    final Uri uri = Uri.parse(this);
    final ShareParams params = ShareParams(uri: uri);
    final ShareResult result = await SharePlus.instance.share(params);
    return result.status == ShareResultStatus.success;
  }

  bool isImageUrl() {
    final List<String> imageExtensions = [
      '.jpg',
      '.jpeg',
      '.png',
      '.gif',
      '.bmp',
      '.webp',
      '.tiff',
    ];
    return imageExtensions.any((ext) => toLowerCase().endsWith(ext));
  }

  void showToast({
    required Color backgroundColor,
    Color textColor = Colors.white,
  }) => Fluttertoast.showToast(
    msg: this,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 2,
    backgroundColor: backgroundColor,
    textColor: Colors.white,
    fontSize: 16.0,
  );

  Future<bool> openUrl(BuildContext context) async {
    // 프로토콜 상대 경로(`//cdn.../x.webp`)는 스킴이 없어 이미지 뷰어가
    // 로드하지 못하므로 https 로 정규화한다.
    final String normalized = startsWith('//') ? 'https:$this' : this;
    final Uri uri = Uri.parse(normalized);
    final String? last = uri.pathSegments.lastOrNull;
    if (last != null && last.isImageUrl()) {
      context.push(Routes.viewPhotoDlgFull, extra: normalized);
      return true;
    }
    return normalized.openBrowser();
  }
}
