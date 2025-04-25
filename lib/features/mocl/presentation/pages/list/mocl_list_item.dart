import 'package:flutter/material.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/round_text_widget.dart';

@immutable
class ListItemProvider extends InheritedWidget {
  final ListItem model;
  final VoidCallback onTap;

  const ListItemProvider({
    super.key,
    required super.child,
    required this.model,
    required this.onTap,
  });

  static ListItemProvider of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ListItemProvider>()!;

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
    final ListItemProvider provider = ListItemProvider.of(context);
    final ListItem item = provider.model;

    return RepaintBoundary(
      child: ListTile(
        minVerticalPadding: 10,
        minTileHeight: 24,
        contentPadding: const EdgeInsets.only(left: 16, right: 12),
        onTap: provider.onTap,
        title: const TitleView(),
        subtitle: item.info.isEmpty ? null : const BottomView(),
      ),
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
    final ListItem item = ListItemProvider.of(context).model;
    final TextStyle textStyle = MoclTextStyles.of(context).title(item.isRead);

    return Text(
      item.title,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: textStyle,
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
    final ListItem item = ListItemProvider.of(context).model;
    final TextStyle textStyle =
        MoclTextStyles.of(context).smallTitle(item.isRead);

    return Text(
      item.info,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: textStyle,
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
    final ListItem item = ListItemProvider.of(context).model;
    final TextStyle textStyle = MoclTextStyles.of(context).badge(item.isRead);
    final bool hasReply = item.reply.isNotEmpty && item.reply != '0';

    return hasReply
        ? SizedBox.shrink()
        : RoundTextWidget(text: item.reply, textStyle: textStyle);
  }
}
