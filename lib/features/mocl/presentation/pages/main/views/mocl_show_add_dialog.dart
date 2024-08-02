import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/controllers/mocl_main_controller.dart';

import '../../../../domain/entities/mocl_main_item.dart';
import '../../../../domain/entities/mocl_result.dart';
import '../../../widgets/check_box_list_title_widget.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/message_widget.dart';

@immutable
class ShowAddDialog extends GetView<MainController> {
  final List<MainItem> selectedItems = [];

  ShowAddDialog({super.key});

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(
          '게시판 선택',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.65,
          height: MediaQuery.of(context).size.height * 0.6,
          child: StreamBuilder<Result>(
            stream: controller.getListFromJson(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                log("snapshot=${snapshot.data.runtimeType}, status=${snapshot.data}");
                if (snapshot.data is ResultLoading) {
                  return const LoadingWidget();
                } else if (snapshot.data is ResultInitial) {
                  return const LoadingWidget();
                } else if (snapshot.data is ResultSuccess<List<MainItem>>) {
                  var result =
                      snapshot.requireData as ResultSuccess<List<MainItem>>;
                  return ListView.separated(
                      shrinkWrap: true,
                      itemCount: result.data.length,
                      itemBuilder: (context, index) {
                        final item = result.data[index];

                        if (item.hasItem) {
                          if (!selectedItems.contains(item)) {
                            selectedItems.add(item);
                          }
                        }

                        return Column(
                          children: [
                            CheckBoxListTitleWidget(
                              text: item.text,
                              checked: item.hasItem || selectedItems.contains(item),
                              textStyle: Theme.of(context).textTheme.bodyMedium,
                              onChanged: (value) {
                                if (value == true) {
                                  if (!selectedItems.contains(item)) {
                                    selectedItems.add(item);
                                  }
                                } else {
                                  if (selectedItems.contains(item)) {
                                    selectedItems.remove(item);
                                  }
                                }
                              },
                            )
                          ],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(
                            height: 1,
                            thickness: 1,
                            indent: 12,
                            endIndent: 8,
                          ));
                } else if (snapshot.data is ResultFailure) {
                  return const MessageWidget(message: 'MainDataError');
                } else {
                  return const MessageWidget(message: 'MainDataError else');
                }
              } else {
                return const LoadingWidget();
              }
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              log('selectedItems=$selectedItems');
              await controller.setList(selectedItems);
              Get.back();
            },
            child: Text(
              '닫기',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      );
}
