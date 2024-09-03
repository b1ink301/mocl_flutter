import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NickImageWidget extends StatefulWidget {
  final String url;
  final double height;

  const NickImageWidget({
    super.key,
    required this.url,
    this.height = 17,
  });

  @override
  State<NickImageWidget> createState() => _NickImageWidgetState();
}

class _NickImageWidgetState extends State<NickImageWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Image(
        key: ValueKey(widget.url),
        image: CachedNetworkImageProvider(widget.url),
        height: widget.height,
        fit: BoxFit.contain,
      ),
    );
  }
}
