import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_detail.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/set_read_flag.dart';
import 'package:mocl_flutter/features/mocl/presentation/base/base_view_model.dart';
import 'package:mocl_flutter/features/mocl/presentation/models/readable_list_item.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailViewModel extends BaseViewModel {
  final ReadableListItem _listItem;
  final GetDetail _getDetail;
  final SetReadFlag _setReadFlag;
  late SiteType _siteType;

  AsyncValue<Details> _data = const AsyncValue.loading();

  AsyncValue<Details> get data => _data;

  AsyncValue<double> _appBarHeight = const AsyncValue.data(64);

  AsyncValue<double> get appBarHeight => _appBarHeight;

  String get smallTitle => '${_siteType.title} > ${_listItem.item.boardTitle}';

  String get title => _listItem.item.title;

  DetailViewModel({
    required ReadableListItem listItem,
    required GetDetail getDetail,
    required SetReadFlag setReadFlag,
    required GetSiteType getSiteType,
  })  : _listItem = listItem,
        _setReadFlag = setReadFlag,
        _getDetail = getDetail {
    _siteType = getSiteType(NoParams());
    _getData();
  }

  void _getData() {
    _data = const AsyncLoading();
    // notifyListeners();

    _getDetail(_listItem.item).then((result) {
      if (result is ResultSuccess<Details>) {
        _data = AsyncData(result.data);
        _markAsRead();
      } else if (result is ResultFailure) {
        _data = AsyncError(result, StackTrace.current);
      } else if (result is ResultLoading) {
        _data = const AsyncLoading();
      } else {
        _data = AsyncError('Unknown Error!', StackTrace.current);
      }
      // notifyListeners();
    }).catchError((e) {
      _data = AsyncError(e.toString(), StackTrace.current);
    });
  }

  void refresh() => _getData();

  Future<bool> openBrowser(String url) async {
    final Uri uri = Uri.parse(url);
    return await launchUrl(uri);
  }

  Future<void> _markAsRead() async {
    if (!_listItem.isRead.value) {
      _listItem.markAsRead();
      var params =
          SetReadFlagParams(siteType: _siteType, boardId: _listItem.item.id);
      await _setReadFlag(params);
    }
  }

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
    )..layout(minWidth: 0, maxWidth: width - (48 + 16 * 2));

    final titleHeight = textPainter.height;
    debugPrint('titleHeight = $titleHeight');

    return max(30, titleHeight) + 36; // 텍스트 높이 반환
  }

  void updateAppbarHeight(
    TextStyle style,
    double width,
  ) {
    _appBarHeight =
        AsyncData(_calculateTitleHeight(_listItem.item.title, style, width));
  }

  @override
  build() {
    // TODO: implement build
    throw UnimplementedError();
  }
}
