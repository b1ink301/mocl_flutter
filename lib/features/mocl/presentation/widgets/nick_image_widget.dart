import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';

class NickImageWidget extends StatelessWidget {
  static const Duration _fadeOutDuration = Duration.zero;
  static const Duration _fadeInDuration = Duration.zero;

  // 메모리 캐시 크기 상수화
  static const int _memCacheHeight = 32; // 실제 높이의 2배로 설정 (고해상도 디스플레이 대응)

  final String url;
  final double height;

  const NickImageWidget({
    super.key,
    required this.url,
    this.height = 16,
  });

  // 이미지 프리로딩을 위한 캐시 매니저
  static final CacheManager _cacheManager = CacheManager(
    Config(
      DefaultCacheManager.key,
      stalePeriod: const Duration(days: 7),
      //one week cache period
    ),
  );

  // 이미지 프리로딩 메서드
  static Future<void> preloadImage(String url) async {
    try {
      // 이미 캐시된 파일이 있는지 확인
      final fileInfo = await _cacheManager.getFileFromCache(url);
      if (fileInfo == null) {
        // 캐시된 파일이 없으면 다운로드
        await _cacheManager.downloadFile(
          url,
          key: url,
        );
        debugPrint('Preloaded image: $url');
      }
    } catch (e) {
      debugPrint('Error preloading image: $e');
    }
  }

  // 여러 이미지 프리로딩
  static Future<void> preloadImages(List<String> urls) async {
    await Future.wait(
      urls.map((url) => preloadImage(url)),
    );
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: CachedNetworkImage(
          // 메모리 캐시 크기 최적화
          memCacheHeight: _memCacheHeight,
          // memCacheWidth: _memCacheHeight, // 정사각형 이미지 가정

          // 페이드 애니메이션 상수화
          fadeOutDuration: _fadeOutDuration,
          fadeInDuration: _fadeInDuration,

          height: height,

          // 에러 처리 추가
          errorWidget: (context, url, error) => const SizedBox.shrink(),

          // 로딩 상태 처리
          placeholder: (context, url) => SizedBox(
            height: height,
            width: height,
          ),

          imageUrl: url,
          cacheKey: url,

          // 이미지 품질 최적화
          fit: BoxFit.contain,
          filterQuality: FilterQuality.low,

          // 캐시 정책 설정
          cacheManager: _cacheManager,
          maxHeightDiskCache: _memCacheHeight,
        ),
      );

  static Future<String> getSizeCacheDir() async {
    final Directory tempDir = await getTemporaryDirectory();
    final Directory libCacheDir =
        Directory("${tempDir.path}/libCachedImageData");

    if (libCacheDir.existsSync()) {
      int totalBytes = 0;
      libCacheDir.listSync(recursive: true).forEach((file) {
        totalBytes += file.statSync().size;
      });

      debugPrint('totalBytes=$totalBytes');

      const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
      final i = (log(totalBytes) / log(1024)).floor();
      final sizeText =
          '${(totalBytes / pow(1024, i)).toStringAsFixed(1)} ${suffixes[i]}';

      debugPrint('sizeText=$sizeText');
      return sizeText;
    }
    return '0 KB';
  }

  // 캐시 관리 메서드들
  static Future<void> clearCache() async {
    // await _cacheManager.emptyCache(); // 모든 캐시 삭제가 안됨.
    final Directory tempDir = await getTemporaryDirectory();
    final Directory libCacheDir =
        Directory("${tempDir.path}/libCachedImageData");
    if (libCacheDir.existsSync()) {
      await libCacheDir.delete(recursive: true);
    } else {
      await Future.delayed(Duration(milliseconds: 300));
    }
  }

  static Future<void> removeFile(String url) async {
    await _cacheManager.removeFile(url.hashCode.toString());
  }
}
