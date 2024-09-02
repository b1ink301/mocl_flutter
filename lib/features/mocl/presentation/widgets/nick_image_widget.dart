import 'dart:async';
import 'dart:ui' as ui;

import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class NickImageWidget extends StatefulWidget {
  final String url;
  final double height;

  const NickImageWidget({
    Key? key,
    required this.url,
    this.height = 17,
  }) : super(key: key);

  @override
  State<NickImageWidget> createState() => _NickImageWidgetState();
}

class _NickImageWidgetState extends State<NickImageWidget> {
  ui.Image? _image;
  static final _memoryCache = <String, ui.Image>{};
  static final _cacheManager = DefaultCacheManager();
  static final _loadingTasks = <String, CancelableOperation<void>>{};
  static const _maxConcurrentLoads = 3;
  static const _maxCacheSize = 100; // Max cache size for LRU strategy

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void dispose() {
    // Cancel the image loading task if the widget is disposed
    if (_loadingTasks.containsKey(widget.url)) {
      _loadingTasks[widget.url]?.cancel();
    }
    super.dispose();
  }

  Future<void> _loadImage() async {
    if (widget.url.isEmpty) return;

    if (_memoryCache.containsKey(widget.url)) {
      setState(() => _image = _memoryCache[widget.url]);
      return;
    }

    if (_loadingTasks.containsKey(widget.url)) {
      await _loadingTasks[widget.url]?.value;
      if (mounted) setState(() => _image = _memoryCache[widget.url]);
      return;
    }

    if (_loadingTasks.length >= _maxConcurrentLoads) {
      await Future.any(_loadingTasks.values.map((task) => task.value));
    }

    _loadingTasks[widget.url] = CancelableOperation.fromFuture(_processImage());
    await _loadingTasks[widget.url]?.value;
    _loadingTasks.remove(widget.url);
  }

  Future<void> _processImage() async {
    try {
      final file = await _cacheManager.getSingleFile(widget.url);
      final bytes = await file.readAsBytes();
      final resizedBytes = await _resizeAndCompressImage(bytes);
      final codec = await ui.instantiateImageCodec(resizedBytes);
      final frameInfo = await codec.getNextFrame();
      _image = frameInfo.image;
      _addToCache(widget.url, _image!);
      if (mounted) setState(() {});
    } catch (e) {
      print('Error loading image: $e');
    }
  }

  @pragma('vm:entry-point')
  Future<Uint8List> _resizeAndCompressImage(Uint8List inputImage) async {
    final image = await decodeImageFromList(inputImage);
    final resizedImage = await _resizeImage(image);
    final data =
        await resizedImage.toByteData(format: ui.ImageByteFormat.png) ??
            ByteData.view(inputImage.buffer);

    return data.buffer.asUint8List();
  }

  Future<ui.Image> _resizeImage(ui.Image image) async {
    final aspectRatio = image.width / image.height;
    final newWidth = (17 * aspectRatio).round();

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.drawImageRect(
      image,
      Rect.fromLTRB(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromLTRB(0, 0, newWidth.toDouble(), 17),
      Paint()..filterQuality = FilterQuality.low,
    );
    final picture = recorder.endRecording();
    return picture.toImage(newWidth, 17);
  }

  void _addToCache(String url, ui.Image image) {
    if (_memoryCache.length >= _maxCacheSize) {
      // Remove the first added item to simulate LRU cache
      _memoryCache.remove(_memoryCache.keys.first);
    }
    _memoryCache[url] = image;
  }

  @override
  Widget build(BuildContext context) {
    if (_image == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: RawImage(
        image: _image,
        height: 17,
        fit: BoxFit.fitHeight,
      ),
    );
  }
}
