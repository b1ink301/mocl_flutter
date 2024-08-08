import 'package:flutter/material.dart';
import 'package:gif/gif.dart';

class NickImageWidget extends StatelessWidget {
  final String url;

  const NickImageWidget({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return const SizedBox.shrink();
    }
    var uri = Uri.tryParse(url);
    if (uri == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Gif(
        image: NetworkImage(url),
        height: 17,
      ),
    );
  }
}
