import 'package:injectable/injectable.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

@injectable
class DetailViewUtil {
  Future<bool> openBrowserByUrl(String url) async {
    final Uri uri = Uri.parse(url);
    return await launchUrl(uri);
  }

  Future<void> shareUrl(String url) async {
    final Uri uri = Uri.parse(url);
    await Share.shareUri(uri);
  }
}