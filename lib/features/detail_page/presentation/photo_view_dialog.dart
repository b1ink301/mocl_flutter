import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:mocl_flutter/core/presentation/widgets/loading_widget.dart';
import 'package:mocl_flutter/core/util/mocl_logger.dart';
import 'package:mocl_flutter/features/network/data/datasources/base_api.dart'
    show userAgentMobile;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/presentation/widgets/plain_icon.dart';
import '../../../core/presentation/widgets/plain_icon_button.dart';
import '../../../core/presentation/widgets/plain_text.dart';
import '../services/file_download_service.dart';

/// 이미지 뷰어로 전달되는 인자. 글/댓글 본문에서 추출한 이미지 URL 목록과
/// 처음 보여줄 인덱스, 그리고 일부 CDN(디시 등) 이 요구하는 Referer 를 담는다.
class GalleryArgs {
  final List<String> urls;
  final int index;
  final String? referer;

  const GalleryArgs({required this.urls, this.index = 0, this.referer});
}

/// 좌우 스와이프로 글 안의 모든 이미지를 넘겨보는 풀스크린 갤러리 뷰어.
/// 핀치 줌(photo_view), 현재 이미지 저장/공유, 하단 페이지 인디케이터를 제공한다.
class PhotoViewDialog extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  /// 본문과 동일하게 실어 보낼 Referer. 비어 있으면 헤더 없이 로드한다.
  final String? referer;

  const PhotoViewDialog({
    super.key,
    required this.imageUrls,
    this.initialIndex = 0,
    this.referer,
  });

  @override
  State<PhotoViewDialog> createState() => _PhotoViewDialogState();
}

class _PhotoViewDialogState extends State<PhotoViewDialog> {
  late final PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, widget.imageUrls.length - 1);
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String get _currentUrl => widget.imageUrls[_currentIndex];

  ImageProvider _providerFor(String url) {
    final String? referer = widget.referer;
    if (referer != null && referer.isNotEmpty) {
      return CachedNetworkImageProvider(
        url,
        headers: {'Referer': referer, 'User-Agent': userAgentMobile},
      );
    }
    return CachedNetworkImageProvider(url);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final focusColor = theme.focusColor;
    final top = MediaQuery.of(context).padding.top;
    final bottom = MediaQuery.of(context).padding.bottom;
    final total = widget.imageUrls.length;

    return Stack(
      children: [
        Positioned.fill(
          child: PhotoViewGallery.builder(
            itemCount: total,
            pageController: _pageController,
            onPageChanged: (int index) =>
                setState(() => _currentIndex = index),
            loadingBuilder: defaultLoading,
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            builder: (BuildContext context, int index) =>
                PhotoViewGalleryPageOptions(
                  imageProvider: _providerFor(widget.imageUrls[index]),
                  minScale: PhotoViewComputedScale.contained,
                  initialScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 4.0,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: PlainIcon(
                      Icons.broken_image_outlined,
                      color: focusColor,
                      size: 48,
                    ),
                  ),
                ),
          ),
        ),
        Positioned(
          top: 10.0 + top,
          right: 10.0,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PlainIconButton(
                onPressed: () => _saveImage(context),
                icon: PlainIcon(Icons.save_alt, color: focusColor),
              ),
              PlainIconButton(
                onPressed: () => _shareImage(context),
                icon: PlainIcon(Icons.share, color: focusColor),
              ),
              PlainIconButton(
                onPressed: () => context.pop(),
                icon: PlainIcon(Icons.close, color: focusColor),
              ),
            ],
          ),
        ),
        if (total > 1)
          Positioned(
            bottom: 16.0 + bottom,
            left: 0,
            right: 0,
            child: Center(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  child: PlainText(
                    '${_currentIndex + 1} / $total',
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Future<Uint8List?> _downloadImage(String url) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: widget.referer != null && widget.referer!.isNotEmpty
            ? {'Referer': widget.referer!, 'User-Agent': userAgentMobile}
            : null,
      );
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
    } catch (e) {
      MoclLogger.log('Image download failed: $e');
    }
    return null;
  }

  String _fileNameOf(String url) {
    final uri = Uri.parse(url);
    final name = uri.pathSegments.lastOrNull ?? 'image.jpg';
    return name.contains('.') ? name : '$name.jpg';
  }

  Future<void> _saveImage(BuildContext context) async {
    final String url = _currentUrl;
    try {
      final fileName = _fileNameOf(url);
      final result = await FileDownloadService.downloadFromUrl(
        url: url,
        fileName: fileName,
      );
      if (result['success'] == true && context.mounted) {
        _showSnackBar(context, '저장되었습니다: $fileName');
      } else if (context.mounted) {
        _showSnackBar(context, '저장에 실패했습니다.');
      }
    } catch (e) {
      MoclLogger.log('Image save failed: $e');
      if (context.mounted) _showSnackBar(context, '저장에 실패했습니다.');
    }
  }

  Future<void> _shareImage(BuildContext context) async {
    final String url = _currentUrl;
    final bytes = await _downloadImage(url);
    if (bytes == null) {
      if (context.mounted) _showSnackBar(context, '이미지 다운로드에 실패했습니다.');
      return;
    }

    try {
      final dir = await getTemporaryDirectory();
      final fileName = _fileNameOf(url);
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
    final style = Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: Colors.white,
    );

    final percentage = (100 * value).floor();
    return Center(child: PlainText('$percentage%', style: style));
  }
}
