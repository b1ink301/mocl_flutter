import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:mocl_flutter/core/presentation/widgets/loading_widget.dart';
import 'package:mocl_flutter/core/util/mocl_logger.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/presentation/widgets/plain_icon.dart';
import '../../../core/presentation/widgets/plain_icon_button.dart';
import '../../../core/presentation/widgets/plain_text.dart';
import '../services/file_download_service.dart';

class PhotoViewDialog extends StatelessWidget {
  final ImageProvider? imageProvider;
  final String? imageUrl;
  final LoadingBuilder? loadingBuilder;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final dynamic initialScale;
  final Alignment? basePosition;
  final FilterQuality? filterQuality;
  final bool? disableGestures;
  final ImageErrorWidgetBuilder? errorBuilder;

  const PhotoViewDialog({
    super.key,
    this.imageProvider,
    this.imageUrl,
    this.loadingBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialScale,
    this.basePosition,
    this.filterQuality,
    this.disableGestures,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final focusColor = theme.focusColor;
    final top = MediaQuery.of(context).padding.top;

    MoclLogger.log('top = $top');

    return Stack(
      children: [
        Positioned.fill(
          child: PhotoView(
            imageProvider: imageProvider,
            loadingBuilder: loadingBuilder ?? defaultLoading,
            backgroundDecoration:
                backgroundDecoration ??
                BoxDecoration(color: Colors.black),
            minScale: minScale,
            maxScale: maxScale,
            initialScale: initialScale,
            basePosition: basePosition,
            filterQuality: filterQuality,
            disableGestures: disableGestures,
            errorBuilder: errorBuilder,
          ),
        ),
        Positioned(
          top: 10.0 + top,
          right: 10.0,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (imageUrl != null) ...[
                PlainIconButton(
                  onPressed: () => _saveImage(context),
                  icon: PlainIcon(Icons.save_alt, color: focusColor),
                ),
                PlainIconButton(
                  onPressed: () => _shareImage(context),
                  icon: PlainIcon(Icons.share, color: focusColor),
                ),
              ],
              PlainIconButton(
                onPressed: () => context.pop(),
                icon: PlainIcon(Icons.close, color: focusColor),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<Uint8List?> _downloadImage() async {
    if (imageUrl == null) return null;
    try {
      final response = await http.get(Uri.parse(imageUrl!));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
    } catch (e) {
      MoclLogger.log('Image download failed: $e');
    }
    return null;
  }

  String _getFileName() {
    if (imageUrl == null) return 'image.jpg';
    final uri = Uri.parse(imageUrl!);
    final name = uri.pathSegments.lastOrNull ?? 'image.jpg';
    return name.contains('.') ? name : '$name.jpg';
  }

  Future<void> _saveImage(BuildContext context) async {
    if (imageUrl == null) {
      if (context.mounted) _showSnackBar(context, '이미지 다운로드에 실패했습니다.');
      return;
    }

    try {
      final fileName = _getFileName();
      final result = await FileDownloadService.downloadFromUrl(
        url: imageUrl!,
        fileName: fileName,
      );
      if (result['success'] == true && context.mounted) {
        _showSnackBar(context, '저장되었습니다: $fileName');
      }
    } catch (e) {
      MoclLogger.log('Image save failed: $e');
      if (context.mounted) _showSnackBar(context, '저장에 실패했습니다.');
    }
  }

  Future<void> _shareImage(BuildContext context) async {
    final bytes = await _downloadImage();
    if (bytes == null) {
      if (context.mounted) _showSnackBar(context, '이미지 다운로드에 실패했습니다.');
      return;
    }

    try {
      final dir = await getTemporaryDirectory();
      final fileName = _getFileName();
      final filePath = p.join(dir.path, fileName);
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      await SharePlus.instance.share(ShareParams(files: [XFile(filePath)]));
    } catch (e) {
      MoclLogger.log('Image share failed: $e');
      if (context.mounted) _showSnackBar(context, '공유에 실패했습니다.');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  Widget defaultLoading(BuildContext context, ImageChunkEvent? event) {
    if (event == null) {
      return const Center(child: LoadingWidget());
    }

    final value =
        event.cumulativeBytesLoaded /
        (event.expectedTotalBytes ?? event.cumulativeBytesLoaded);
    final style = Theme.of(context).textTheme.bodyMedium!;

    final percentage = (100 * value).floor();
    return Center(child: PlainText("$percentage%", style: style));
  }
}
