import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_detail.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/set_read_flag.dart';
import 'package:mocl_flutter/features/mocl/presentation/models/readable_list_item.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

part 'detail_view_bloc.freezed.dart';

part 'detail_view_event.dart';

part 'detail_view_state.dart';

@injectable
class DetailViewBloc extends Bloc<DetailViewEvent, DetailViewState> {
  final GetDetail _getDetail;
  final SetReadFlag _setReadFlag;

  late final ReadableListItem _listItem;
  late final SiteType _siteType;

  DetailViewBloc(this._getDetail, this._setReadFlag)
      : super(const DetailLoading()) {
    on<DetailsEvent>(_onDetailsEvent);
    on<HeightEvent>(_onHeightEvent);
  }

  init(ReadableListItem item, SiteType siteType) {
    _listItem = item;
    _siteType = siteType;
  }

  String get smallTitle => '${_siteType.title} > ${_listItem.item.boardTitle}';

  String get title => _listItem.item.title;

  void refresh() => add(const DetailsEvent());

  Future<void> _onDetailsEvent(
    DetailsEvent event,
    Emitter<DetailViewState> emit,
  ) async {
    emit(const DetailLoading());
    try {
      final result = await _getDetail(_listItem.item);
      if (result is ResultSuccess<Details>) {
        emit(DetailSuccess(result.data));
        await _markAsRead();
      } else if (result is ResultFailure) {
        emit(DetailFailed(result.toString()));
      } else if (result is ResultLoading) {
      } else {
        emit(const DetailFailed('Unknown Error!'));
      }
    } catch (e) {
      emit(DetailFailed(e.toString()));
    }
  }

  Future<void> _onHeightEvent(
    HeightEvent event,
    Emitter<DetailViewState> emit,
  ) async {
    final height = _calculateTitleHeight(event.text, event.style, event.width);
    emit(DetailHeight(height));
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
    debugPrint('titleHeight = ${titleHeight + 36}');

    return max(30, titleHeight) + 36; // 텍스트 높이 반환
  }

  Future<void> _markAsRead() async {
    if (!_listItem.isRead.value) {
      _listItem.markAsRead();
      var params =
          SetReadFlagParams(siteType: _siteType, boardId: _listItem.item.id);
      await _setReadFlag(params);
    }
  }

  Future<bool> openBrowserByItem() async {
    final url = _listItem.item.url;
    final Uri uri = Uri.parse(url);
    return await launchUrl(uri);
  }

  Future<bool> openBrowser(String url) async {
    final Uri uri = Uri.parse(url);
    return await launchUrl(uri);
  }

  void shareUri() {
    final url = _listItem.item.url;
    final Uri uri = Uri.parse(url);
    Share.shareUri(uri);
  }
}
