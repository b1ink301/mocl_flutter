import 'package:flutter/material.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';
import 'package:mocl_flutter/features/mocl/presentation/models/readable_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/round_text_widget.dart';

@immutable
class ReadableListItemProvider extends InheritedWidget {
  final ReadableListItem model;
  final VoidCallback onTap;

  const ReadableListItemProvider({
    super.key,
    required super.child,
    required this.model,
    required this.onTap,
  });

  static ReadableListItemProvider of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ReadableListItemProvider>()!;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}

@immutable
class MoclListItem extends StatelessWidget {
  const MoclListItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ReadableListItemProvider provider =
        ReadableListItemProvider.of(context);
    return ListTile(
      minVerticalPadding: 10,
      minTileHeight: 24,
      contentPadding: const EdgeInsets.only(left: 16, right: 12),
      onTap: provider.onTap,
      title: const TitleView(),
      subtitle: const BottomView(),
    );
  }
}

@immutable
class TitleView extends StatelessWidget {
  const TitleView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ReadableListItem model = ReadableListItemProvider.of(context).model;
    return ValueListenableBuilder(
      valueListenable: model.isRead,
      builder: (BuildContext context, bool isRead, Widget? child) => Text(
        model.item.title,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: MoclTextStyles.of(context).title(isRead),
      ),
    );
  }
}

@immutable
class BottomView extends StatelessWidget {
  const BottomView({
    super.key,
  });

  @override
  Widget build(BuildContext context) => const Column(
        children: [
          SizedBox(height: 8),
          SizedBox(
            height: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      // if (nickImage.isNotEmpty && nickImage.startsWith('http'))
                      //   NickImageWidget(url: nickImage),
                      Flexible(
                        child: InfoText(),
                      ),
                    ],
                  ),
                ),
                ReplyBadge(),
              ],
            ),
          ),
        ],
      );
}

@immutable
class InfoText extends StatelessWidget {
  const InfoText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ReadableListItem model = ReadableListItemProvider.of(context).model;
    final String info = model.item.info;

    return ValueListenableBuilder(
      valueListenable: model.isRead,
      builder: (BuildContext context, bool isRead, Widget? child) {
        return Text(
          info,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: MoclTextStyles.of(context).smallTitle(isRead),
        );
      },
    );
  }
}

@immutable
class ReplyBadge extends StatelessWidget {
  const ReplyBadge({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ReadableListItem model = ReadableListItemProvider.of(context).model;
    final String reply = model.item.reply;
    final bool hasReply = reply.isNotEmpty && reply != '0';

    return !hasReply
        ? const SizedBox.shrink()
        : ValueListenableBuilder(
            valueListenable: model.isRead,
            builder: (BuildContext context, bool isRead, Widget? child) =>
                RoundTextWidget(
              text: reply,
              textStyle: MoclTextStyles.of(context).badge(isRead),
            ),
          );
  }
}
