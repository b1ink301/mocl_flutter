import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/core/presentation/widgets/loading_widget.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewDialog extends StatelessWidget {
  final ImageProvider? imageProvider;
  final LoadingBuilder? loadingBuilder;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final dynamic initialScale;
  final Alignment? basePosition;
  final FilterQuality? filterQuality;
  final bool? disableGestures;
  final ImageErrorWidgetBuilder? errorBuilder;

  const PhotoViewDialog({
    super.key,
    this.imageProvider,
    this.loadingBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialScale,
    this.basePosition,
    this.filterQuality,
    this.disableGestures,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) => SafeArea(
    left: false,
    right: false,
    child: Stack(
      children: [
        Positioned.fill(
          child: PhotoView(
            imageProvider: imageProvider,
            loadingBuilder: loadingBuilder ?? defaultLoading,
            backgroundDecoration:
                backgroundDecoration ??
                BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
            minScale: minScale,
            maxScale: maxScale,
            initialScale: initialScale,
            basePosition: basePosition,
            filterQuality: filterQuality,
            disableGestures: disableGestures,
            errorBuilder: errorBuilder,
          ),
        ),
        Positioned(
          top: 10.0,
          right: 10.0,
          child: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.close),
          ),
        ),
      ],
    ),
  );

  Widget defaultLoading(BuildContext context, ImageChunkEvent? event) {
    if (event == null) {
      return const Center(child: LoadingWidget());
    }

    final value =
        event.cumulativeBytesLoaded /
        (event.expectedTotalBytes ?? event.cumulativeBytesLoaded);

    final percentage = (100 * value).floor();
    return Center(
      child: Text(
        "$percentage%",
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
