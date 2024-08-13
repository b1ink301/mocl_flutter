import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';

class NickImageWidget extends StatelessWidget {
  final String url;
  final SiteType siteType;

  const NickImageWidget({
    super.key,
    required this.url,
    required this.siteType,
  });

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Gif(
        image: NetworkImage(url),
        height: 17,
        width: siteType == SiteType.damoang ? 17 : 63.8,
      ),
    );
  }
}
