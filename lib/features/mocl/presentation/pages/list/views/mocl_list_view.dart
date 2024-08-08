import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/loading_widget.dart';

import '../controllers/mocl_list_controller.dart';
import 'mocl_cached_list_item.dart';

class ListView extends StatefulWidget {
  const ListView({super.key});

  @override
  State createState() => _ListViewState();
}

class _ListViewState extends State<ListView> {
  final ListController _listController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Obx(
        () => SliverList.separated(
          itemBuilder: (BuildContext context, int index) {
            if (index < _listController.items.length) {
              final item = _listController.items[index];
              if (kDebugMode) {
                Get.log('SliverList index=$index');
              }
              return CachedListItem(
                key: ValueKey(item.item.id),
                item: item,
                onTap: () => _listController.toDetail(item),
              );
            }
            if (index == _listController.items.length &&
                _listController.isLoadingMore.value) {
              return const LoadingWidget();
            }
            return null;
          },
          separatorBuilder: (context, index) => const Divider(
            indent: 16,
            endIndent: 4,
          ),
          itemCount: _listController.items.length +
              (_listController.isLoadingMore.value ? 1 : 0),
        ),
      );
}
