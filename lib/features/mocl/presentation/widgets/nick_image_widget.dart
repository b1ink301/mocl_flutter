import 'package:cached_network_image/cached_network_image.dart';
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
      child: Image(
        image: CachedNetworkImageProvider(url),
        height: 17,
      ),
    );
  }

// @override
// Widget build(BuildContext context) {
//   if (url.isEmpty) {
//     return const SizedBox.shrink();
//   }
//   var uri = Uri.tryParse(url);
//   if (uri == null) {
//     return const SizedBox.shrink();
//   }
//   return Padding(
//     padding: const EdgeInsets.only(right: 8),
//     child: CachedNetworkImage(
//       imageUrl: url,
//       height: 17,
//     ),
//   );
// }
}
