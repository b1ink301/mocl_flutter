import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

class NickImageWidget extends StatefulWidget {
  final String url;
  final double height;

  const NickImageWidget({
    super.key,
    required this.url,
    this.height = 17,
  });

  @override
  _NickImageWidgetState createState() => _NickImageWidgetState();
}

class _NickImageWidgetState extends State<NickImageWidget> {
  Uint8List? _firstFrameBytes;
  final BaseCacheManager _cacheManager = DefaultCacheManager();
  static final _loadingSemaphore = Semaphore(3);
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _loadFirstFrame();
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  Future<void> _loadFirstFrame() async {
    if (widget.url.isEmpty) return;

    await _loadingSemaphore.acquire();
    try {
      if (!_isMounted) return;

      final fileInfo = await _cacheManager.getFileFromCache(widget.url);
      if (fileInfo != null) {
        _firstFrameBytes = await fileInfo.file.readAsBytes();
      } else {
        final response = await http.get(Uri.parse(widget.url));
        if (response.statusCode == 200) {
          _firstFrameBytes =
              await compute(_extractFirstFrame, response.bodyBytes);
          await _cacheManager.putFile(widget.url, _firstFrameBytes!);
        }
      }
      if (_isMounted) {
        setState(() {});
      }
    } catch (e) {
      if (_isMounted) {
        print('Error loading GIF: $e, ${widget.url}');
      }
    } finally {
      _loadingSemaphore.release();
    }
  }

  static Future<Uint8List> _extractFirstFrame(Uint8List data) async {
    final decoder = img.findDecoderForData(data);
    if (decoder != null) {
      final info = decoder.startDecode(data);
      if (info != null) {
        final firstFrame = decoder.decodeFrame(0);
        if (firstFrame != null) {
          return Uint8List.fromList(img.encodePng(firstFrame));
        }
      }
    }
    throw Exception('Failed to extract GIF first frame');
  }

  @override
  Widget build(BuildContext context) => _firstFrameBytes == null
      ? const SizedBox.shrink()
      : Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Image.memory(
            _firstFrameBytes!,
            height: widget.height,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const SizedBox.shrink();
            },
          ),
        );
}

class Semaphore {
  final int _maxCount;
  int _currentCount;
  final List<Completer<void>> _waitQueue = [];

  Semaphore(this._maxCount) : _currentCount = _maxCount;

  Future<void> acquire() async {
    if (_currentCount > 0) {
      _currentCount--;
      return;
    }
    final completer = Completer<void>();
    _waitQueue.add(completer);
    return completer.future;
  }

  void release() {
    if (_waitQueue.isNotEmpty) {
      final completer = _waitQueue.removeAt(0);
      completer.complete();
    } else {
      _currentCount = min(_currentCount + 1, _maxCount);
    }
  }
}
