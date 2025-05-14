import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/presentation/injection.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/bloc/list_item_cubit.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/readable_flag.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/bloc/site_type_bloc.dart';
import 'package:mocl_flutter/features/mocl/presentation/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/round_text_widget.dart';

@immutable
class MoclListItem extends StatelessWidget {
  const MoclListItem({super.key});

  void _onTap(BuildContext context, ListItem item) {
    final SiteType siteType = context.read<SiteTypeBloc>().state;
    final List<Object> extra = [siteType, item];
    final ReadableFlag readableFlag = getIt<ReadableFlag>()..id = -1;

    GoRouter.of(context).push(Routes.detail, extra: extra).then((_) {
      if (!context.mounted) {
        return;
      }
      if (readableFlag.id == item.id) {
        context.read<ListItemCubit>().markAsRead();
      }
    });
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<ListItemCubit, ListItem>(
    buildWhen: (previous, current) => previous.isRead != current.isRead,
    builder:
        (context, item) => InkWell(
          onTap: () => _onTap(context, item),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                item.title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: MoclTextStyles.of(context).title(item.isRead),
              ),
              const SizedBox(height: 10),
              _BottomWidget(
                reply: item.reply,
                info: item.info,
                isRead: item.isRead,
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
  );
}

class _BottomWidget extends StatelessWidget {
  const _BottomWidget({
    required this.info,
    required this.reply,
    required this.isRead,
  });

  final String info;
  final String reply;
  final bool isRead;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 20,
    child: Row(
      children: [
        Expanded(
          child: Text(
            info,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: MoclTextStyles.of(context).smallTitle(isRead),
          ),
        ),
        if (reply.isNotEmpty && reply != '0')
          RoundTextWidget(
            text: reply,
            textStyle: MoclTextStyles.of(context).badge(isRead),
          ),
      ],
    ),
  );
}
