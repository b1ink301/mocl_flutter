import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NickImageWidget extends StatelessWidget {
  final String url;

  const NickImageWidget({
    super.key,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return const SizedBox.shrink();
    }

    // return Padding(
    //   padding: const EdgeInsets.only(right: 8),
    //   child: Gif(
    //     key: ValueKey(url),
    //     image: NetworkImage(url),
    //     height: 17,
    //     width: siteType == SiteType.damoang ? 17 : 63.8,
    //   ),
    // );

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: CachedNetworkImage(
          key: ValueKey(url),
          height: 17,
          imageUrl: url,
          errorWidget: (context, url, error) => const SizedBox.shrink()),
    );
  }
}
