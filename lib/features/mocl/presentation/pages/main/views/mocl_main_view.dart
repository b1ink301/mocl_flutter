import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/providers/main_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/message_widget.dart';

import '../../../../domain/entities/mocl_main_item.dart';
import '../../../widgets/loading_widget.dart';

class MainView extends ConsumerWidget {
  final SiteType siteType;

  const MainView({super.key, required this.siteType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    final resultAsync = ref.watch(mainListStateProvider);
    debugPrint('[MainView] resultAsync = $resultAsync');

    return resultAsync.when(
      data: (result) {
        debugPrint('[MainView] result = ${result.runtimeType}');

        if (result is ResultSuccess<List<MainItem>>) {
          return ListView.separated(
            itemCount: result.data.length,
            itemBuilder: (context, index) {
              final item = result.data[index];
              return ListTile(
                key: ValueKey(item.board),
                minTileHeight: 64,
                title: Text(
                  item.text,
                  style: textStyle,
                ),
                onTap: () => context.push(Routes.LIST, extra: item),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const DividerWidget(),
          );
        } else {
          return MessageWidget(message: 'message ${result.runtimeType}');
        }
      },
      error: (e, s) => Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          '에러가 발생했습니다',
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).indicatorColor,
          ),
        ),
      ),
      loading: () => const LoadingWidget(),
    );
  }
}
