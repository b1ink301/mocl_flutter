import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/mocl_main_controller.dart';

import '../../../domain/entities/mocl_main_item.dart';
import '../../../domain/entities/mocl_result.dart';
import '../../widgets/check_box_list_title_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/message_widget.dart';

@immutable
class ShowAddDialog extends GetView<MainController> {
  final List<MainItem> selectedItems = [];

  ShowAddDialog({super.key});

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('게시판 선택'),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          height: MediaQuery.of(context).size.width * 0.8,
          child: StreamBuilder<Result>(
            stream: controller.getListFromJson(controller.siteType),
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
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: result.data.length,
                    itemBuilder: (context, index) {
                      final item = result.data[index];

                      if (item.hasItem) {
                        selectedItems.add(item);
                      }
                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          CheckBoxListTitleWidget(
                            text: item.text,
                            checked: item.hasItem,
                            onChanged: (value) {
                              if (value == true) {
                                selectedItems.add(item);
                              } else {
                                selectedItems.remove(item);
                              }
                            },
                          )
                        ],
                      );
                    },
                  );
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
              await controller.setList(controller.siteType, selectedItems);
              Get.back();
            },
            child: const Text('닫기'),
          ),
        ],
      );
}
