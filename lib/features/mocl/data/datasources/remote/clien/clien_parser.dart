import 'dart:async';

import 'package:dartx/dartx.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/base/base_parser.dart';
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

part 'clien_ext.dart';

class ClienParser implements BaseParser {
  const ClienParser();

  @override
  SiteType get siteType => SiteType.clien;

  @override
  String get baseUrl => 'https://m.clien.net';

  @override
  Future<Either<Failure, List<MainItem>>> main(Response response) async {
    try {
      final document = parse(response.data);
      var index = 0;
      final List<MainItem> list = document
          .querySelectorAll(
              "div.navigation > div.menu_list > div.swiper-wrapper > div.menu_slide > div > ul > li")
          .map((element) => element._toMainItem(baseUrl, index++))
          .whereType<MainItem>()
          .distinctBy((element) => element.board)
          .toList();

      return Right(list);
    } catch (e) {
      return Left(GetMainFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CommentItem>>> comments(Response response) async {
    try {
      var index = 0;
      final document = parse(response.data);
      final List<CommentItem> comments = document
          .querySelectorAll("div.comment_row")
          .map((element) => element._toComments(index++))
          .whereType<CommentItem>()
          .toList();

      return Right(comments);
    } catch (e) {
      return Left(GetCommentsFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Details>> detail(Response response) async {
    try {
      timeago.setLocaleMessages('ko', timeago.KoMessages());

      final document = parse(response.data);
      var index = 0;
      final container =
          document.querySelector('body > div.nav_container > div.content_view');

      final comments = container
              ?.querySelectorAll(
                  "div.post_comment > div.comment > div.comment_row")
              .map((element) => element._toComments(index++))
              .whereType<CommentItem>()
              .toList() ??
          const [];

      return Right(container!._toDetails(comments));
    } catch (e) {
      return Left(GetDetailFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ListItem>>> list(
      Response response,
      LastId lastId,
      String title,
      Future<List<int>> Function(SiteType, List<int>) isReads) async {
    try {
      timeago.setLocaleMessages('ko', timeago.KoMessages());
      final Document document = parse(response.data);
      final List<Element> elements =
          document.querySelectorAll("a.list_item.symph-row");

      final List<ListItem> list = [];
      for (final element in elements) {
        final ListItem? item =
            element._toListItem(lastId.intId, baseUrl, title);
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
  String urlByList(
      String url, String board, int page, SortType sortType, LastId lastId) {
    final String sort = sortType.toQuery(siteType);
    return board == "recommend"
        ? url
        : 'https://m.clien.net/service/api/board/under/list?category=0&boardSn=0&po=$page$sort&boardCd=$board';
  }

  @override
  String urlBySearchList(
          String url, String board, int page, String keyword, LastId lastId) =>
      'https://m.clien.net/service/api/board/under/list?category=0&boardSn=0&po=$page&boardCd=$board&sk=title&sv=$keyword';

  @override
  String urlByMain() => baseUrl;

  @override
  String urlByComments(String url, String board, int id, int page) =>
      'https://m.clien.net/service/board/$board/$id/comment?order=date&po=$page&ps=999999webTag=ST03';
}
