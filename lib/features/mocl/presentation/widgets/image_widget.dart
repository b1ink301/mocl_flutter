import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final String url;

  const ImageWidget({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return const SizedBox.shrink();
    }
    var uri = Uri.tryParse(url);
    if (uri == null) {
      return const SizedBox.shrink();
    }

    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.contain,
      height: 18,
    );
  }
}
