import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/providers/list_providers.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/nick_image_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/round_text_widget.dart';

class MoclListItem extends ConsumerWidget {
  static const _iosPadding = EdgeInsets.only(
    left: 16,
    right: 12,
    top: 10,
    bottom: 10,
  );

  static const _aosPadding = EdgeInsets.only(left: 16, right: 12);

  const MoclListItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasInfo = ref.watch(
      listItemProvider.select(
        (ListItem? item) => item?.info.isNotEmpty ?? false,
      ),
    );
    return PlatformListTile(
      material: (_, _) => MaterialListTileData(
        minVerticalPadding: 6,
        contentPadding: _aosPadding,
      ),
      cupertino: (_, _) => CupertinoListTileData(padding: _iosPadding),
      onTap: () => ref.read(handleItemTapProvider(context)),
      title: const _TitleView(),
      subtitle: hasInfo ? const _BottomView() : null,
    );
  }
}

class _TitleView extends ConsumerWidget {
  const _TitleView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (title, isRead) = ref.watch(
      listItemProvider.select(
        (ListItem? item) => (item?.title ?? "", item?.isRead ?? false),
      ),
    );

    return PlatformText(
      title,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: MoclTextStyles.of(context).title(isRead),
    );
  }
}

class _BottomView extends StatelessWidget {
  const _BottomView();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.only(top: 8.0),
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

class _ReplyText extends ConsumerWidget {
  const _ReplyText();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (reply, isRead) = ref.watch(
      listItemProvider.select(
        (ListItem? item) => (item?.reply ?? "", item?.isRead ?? false),
      ),
    );

    if (reply.isNotEmpty && reply != '0') {
      return RoundTextWidget(
        text: reply,
        textStyle: MoclTextStyles.of(context).badge(isRead),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}

class _NickImage extends ConsumerWidget {
  const _NickImage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final url = ref.watch(
      listItemProvider.select(
        (ListItem? item) => item?.userInfo.nickImage ?? "",
      ),
    );

    if (url.isEmpty) {
      return SizedBox.shrink();
    }
    return NickImageWidget(url: url);
  }
}

class _InfoText extends ConsumerWidget {
  const _InfoText();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (info, isRead) = ref.watch(
      listItemProvider.select(
        (ListItem? item) => (item?.info ?? "", item?.isRead ?? false),
      ),
    );

    if (info.isEmpty) {
      return SizedBox.shrink();
    }
    return PlatformText(
      info,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: MoclTextStyles.of(context).smallTitle(isRead),
    );
  }
}
