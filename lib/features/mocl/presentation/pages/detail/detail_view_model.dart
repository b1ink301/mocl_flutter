import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_detail.dart';
import 'package:mocl_flutter/features/mocl/presentation/base/base_view_model.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/view_model_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/models/readable_list_item.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailViewModel extends BaseViewModel {
  final ReadableListItem _listItem;
  final GetDetail _getDetail;
  AsyncValue<Details> _data = const AsyncValue.loading();

  AsyncValue<Details> get data => _data;

  AsyncValue<double> _appBarHeight = const AsyncValue.data(64);

  AsyncValue<double> get appBarHeight => _appBarHeight;

  DetailViewModel({
    required ReadableListItem listItem,
    required GetDetail getDetail,
  })  : _listItem = listItem,
        _getDetail = getDetail {
    _getData();
  }

  void _getData() {
    _data = const AsyncLoading();
    notifyListeners();

    _getDetail(_listItem.item).then((result) {
      if (result is ResultSuccess<Details>) {
        _data = AsyncData(result.data);
        _markAsRead();
      } else if (result is ResultFailure) {
        _data = AsyncError(result, StackTrace.current);
      } else {}
      notifyListeners();
    });
  }

  void refresh() {
    _getData();
  }

  Future<bool> openBrowser(String url) async {
    final Uri uri = Uri.parse(url);
    return await launchUrl(uri);
  }

  void _markAsRead() => _listItem.markAsRead();

  double _calculateTitleHeight(
    String text,
    TextStyle style,
    double width,
  ) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: style,
      ),
      maxLines: 3,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: width - (48 + 16 * 2 + 16 + 4));

    final titleHeight = textPainter.height;
    debugPrint('titleHeight = $titleHeight');

    return max(30, titleHeight) + 34; // 텍스트 높이 반환
  }

  void updateAppbarHeight(
    TextStyle style,
    double width,
  ) {
    _appBarHeight =
        AsyncData(_calculateTitleHeight(_listItem.item.title, style, width));
  }
}
