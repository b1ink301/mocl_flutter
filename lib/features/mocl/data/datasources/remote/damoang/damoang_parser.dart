import 'dart:async';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/base/base_ext.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/base/base_parser.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/last_id.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_comment_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_user_info.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/sort_type.dart';
import 'package:timeago/timeago.dart' as timeago;

part 'damoang_ext.dart';

class DamoangParser implements BaseParser {
  final bool isShowNickImage;

  const DamoangParser(this.isShowNickImage);

  @override
  SiteType get siteType => SiteType.damoang;

  @override
  String get baseUrl => 'https://damoang.net';

  @override
  Future<Either<Failure, List<MainItem>>> main(Response response) =>
      throw UnimplementedError('main');

  @override
  Future<Either<Failure, List<CommentItem>>> comments(Response response) =>
      throw UnimplementedError('comment');

  @override
  Future<Either<Failure, Details>> detail(Response response) async {
    try {
      timeago.setLocaleMessages('ko', timeago.KoMessages());
      final document = parse(response.data);
      final container = document.querySelector('article[id=bo_v]');
      var index = 0;
      final comments = container
              ?.querySelectorAll('div[id=viewcomment] > section > article')
              .map((element) => element._toComment(index++, false))
              .whereType<CommentItem>()
              .toList() ??
          [];
      return Right(container!._toDetails(comments));
    } catch (e) {
      return Left(GetDetailFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ListItem>>> list(
    Response response,
    LastId lastId,
    String boardTitle,
    Future<List<int>> Function(SiteType, List<int>) isReads,
  ) async {
    try {
      timeago.setLocaleMessages('ko', timeago.KoMessages());
      final list = <ListItem>[];
      final document = parse(response.data);
      final elementList = document.querySelectorAll(
          'form[id=fboardlist] > section[id=bo_list] > ul.list-group > li.list-group-item > div.d-flex');
      for (final element in elementList) {
        final item = element._toListItem(
            lastId.intId, baseUrl, boardTitle, isShowNickImage);
        if (item == null) continue;
        final List<int> readState = await isReads(siteType, [item.id]);
        list.add(item.copyWith(isRead: readState.contains(item.id)));
      }
      return Right(list);
    } catch (e) {
      return Left(GetListFailure(message: e.toString()));
    }
  }

  @override
  String urlByDetail(
    String url,
    String board,
    int id,
  ) =>
      url;

  @override
  String urlByList(
    String url,
    String board,
    int page,
    SortType sortType,
    LastId lastId,
  ) =>
      '$url?page=$page${sortType.toQuery(siteType)}';

  @override
  String urlBySearchList(
    String url,
    String board,
    int page,
    String keyword,
    LastId lastId,
  ) =>
      '$url?page=$page&sfl=wr_subject&sop=and&stx=$keyword';

  @override
  String urlByMain() {
    throw UnimplementedError('urlByMain');
  }

  @override
  String urlByComments(String url, String board, int id, int page) {
    throw UnimplementedError();
  }
}
