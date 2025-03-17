import 'dart:async';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/base/base_ext.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/last_id.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_comment_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_user_info.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/sort_type.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../base/base_parser.dart';

part 'meeco_ext.dart';

class MeecoParser implements BaseParser {
  const MeecoParser();

  @override
  SiteType get siteType => SiteType.meeco;

  @override
  String get baseUrl => 'https://meeco.kr';

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
      final container = document.querySelector('article.atc');
      var index = 0;
      final List<CommentItem> comments = container
              ?.querySelectorAll(
                  'div.cmt > div.cmt_list_parent > div.cmt_list > article')
              .map((element) => element._toComments(baseUrl, index++))
              .whereType<CommentItem>()
              .toList() ??
          [];

      final detail = container!._toDetails(baseUrl, comments);
      return Right(detail);
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
      final document = parse(response.data).body;
      if (document == null) {
        throw GetListFailure(message: 'document is null');
      }
      final List<ListItem> list = [];
      final elementList = document.querySelectorAll(
          'div.wrap > section[id=container] > div > section.ctt > section.neon_board > div[id=list_swipe_area] > div.list_ctt > div.list_document > div.list_d > ul > li');
      for (final element in elementList) {
        final item =
            element._toListItem(lastId.intId, baseUrl, boardTitle, false);
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
  String urlByDetail(String url, String board, int id) => url;

  @override
  String urlByList(String url, String board, int page, SortType sortType,
          LastId lastId) =>
      '$url?page=$page${sortType.toQuery(siteType)}';

  @override
  String urlBySearchList(
      String url, String board, int page, String keyword, LastId lastId) {
    throw UnimplementedError('urlBySearchList');
  }

  @override
  String urlByMain() => throw UnimplementedError('urlByMain');

  @override
  String urlByComments(String url, String board, int id, int page) =>
      throw UnimplementedError();
}
