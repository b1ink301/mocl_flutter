import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/core/presentation/widgets/nick_image_widget.dart';
import 'package:mocl_flutter/core/presentation/widgets/round_text_widget.dart';
import 'package:mocl_flutter/features/list_page/presentation/state/list_event_mixin.dart';

import '../state/list_state_mixin.dart';

class MoclListItem extends ConsumerWidget with ListState, ListEvent {
  static const _iosPadding = EdgeInsets.only(
    left: 16,
    right: 12,
    top: 10,
    bottom: 10,
  );

  static const _aosPadding = EdgeInsets.only(left: 16, right: 12);

  const MoclListItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => PlatformListTile(
    material: (_, _) => MaterialListTileData(
      minVerticalPadding: 6,
      contentPadding: _aosPadding,
    ),
    cupertino: (_, _) => CupertinoListTileData(padding: _iosPadding),
    onTap: () => handleItemTap(ref, context),
    title: const _TitleView(),
    subtitle: hasInfoState(ref) ? const _BottomView() : null,
  );
}

class _TitleView extends ConsumerWidget with ListState {
  const _TitleView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (title, textStyle) = titleViewState(ref);
    return PlatformText(
      title,
      maxLines: 3,
      overflow: .ellipsis,
      style: textStyle,
    );
  }
}

class _BottomView extends StatelessWidget {
  const _BottomView();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: .only(top: 8.0),
    child: SizedBox(
      height: 20,
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                _NickImage(),
                Flexible(child: _InfoText()),
              ],
            ),
          ),
          _ReplyText(),
        ],
      ),
    ),
  );
}

class _ReplyText extends ConsumerWidget with ListState {
  const _ReplyText();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (reply, textStyle) = replyViewState(ref, context);
    return reply.isNotEmpty && reply != '0'
        ? RoundTextWidget(text: reply, textStyle: textStyle)
        : const SizedBox.shrink();
  }
}

class _NickImage extends ConsumerWidget with ListState {
  const _NickImage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final url = nickImageState(ref);
    return url.isEmpty ? const SizedBox.shrink() : NickImageWidget(url: url);
  }
}

class _InfoText extends ConsumerWidget with ListState {
  const _InfoText();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (info, textStyle) = infoViewState(ref);
    return info.isEmpty
        ? const SizedBox.shrink()
        : PlatformText(
            info,
            maxLines: 1,
            overflow: .ellipsis,
            style: textStyle,
          );
  }
}
