import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NickImageWidget extends StatelessWidget {
  final String url;
  final double height;

  const NickImageWidget({
    super.key,
    required this.url,
    this.height = 16,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: 8),
    child: CachedNetworkImage(
      memCacheHeight: height.toInt(),
      height: height,
      fit: BoxFit.contain,
      imageUrl: url,
      cacheKey: url,
    ),
  );
}
