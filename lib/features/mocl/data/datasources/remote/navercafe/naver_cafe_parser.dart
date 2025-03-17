import 'dart:async';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/error/failures.dart';
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

part 'naver_cafe_ext.dart';

class NaverCafeParser implements BaseParser {
  const NaverCafeParser();

  @override
  SiteType get siteType => SiteType.naverCafe;

  @override
  String get baseUrl => 'https://m.cafe.naver.com';

  @override
  Future<Either<Failure, List<MainItem>>> main(Response response) async {
    final Map<String, dynamic> json = response.data['message'];
    final String status = json['status'];
    if (status != '200') {
      final Map<String, dynamic> error = json['error'];
      final String code = error['code'];
      final String msg = error['msg'];
      if (code == '0004') {
        return Left(NotLoginFailure(message: msg));
      } else {
        return Left(GetMainFailure(message: msg));
      }
    } else {
      final List<dynamic> cafes = json['result']['cafes'];
      var orderBy = 0;
      final List<MainItem> data = cafes.map((cafe) {
        Map<String, dynamic> json = {
          'siteType': siteType.name,
          'orderBy': orderBy++,
          'url': cafe['cafeId'].toString(),
          'board': cafe['cafeUrl'],
          'text': cafe['mobileCafeName'],
          'icon': cafe['cafeIconImageUrl'],
          'hasItem': false,
          'type': 0,
        };
        return MainItem.fromJson(json);
      }).toList();

      return Right(data);
    }
  }

  @override
  Future<Either<Failure, List<CommentItem>>> comments(Response response) =>
      throw UnimplementedError('comment');

  @override
  Future<Either<Failure, Details>> detail(Response response) async {
    timeago.setLocaleMessages('ko', timeago.KoMessages());
    final commentResult = response.data.last['result'];
    final commentList = commentResult['comments']['items'];
    int index = 0;
    final comments = commentList
        .map((comment) => _toComments(comment, index++))
        .whereType<CommentItem>()
        .toList();
    final detail = response.data.first['result'];
    return Right(_toDetails(detail, comments));
  }

  @override
  Future<Either<Failure, List<ListItem>>> list(
    Response response,
    LastId lastId,
    String boardTitle,
    Future<List<int>> Function(SiteType, List<int>) isReads,
  ) async {
    timeago.setLocaleMessages('ko', timeago.KoMessages());
    final result = response.data['message']['result'];
    final articleList = result['articleList'];
    final List<ListItem> list = [];
    for (final Map<String, dynamic> article in articleList) {
      final item =
          _toListItem(article, lastId.intId, baseUrl, boardTitle, false);
      if (item == null) continue;
      final List<int> readState = await isReads(siteType, [item.id]);
      list.add(item.copyWith(isRead: readState.contains(item.id)));
    }
    return Right(list);
  }

  @override
  String urlByDetail(
    String url,
    String board,
    int id,
  ) =>
      'https://apis.naver.com/cafe-web/cafe-articleapi/v3/cafes/$board/articles/$id';

  // 'https://apis.naver.com/cafe-web/cafe-articleapi/v2/cafes/$board/articles/$id'; //?query=&useCafeId=true&requestFrom=A

  @override
  String urlByList(
      String url, String board, int page, SortType sortType, LastId lastId) {
    // final String sort = sortType.toQuery(siteType);
    return "https://apis.naver.com/cafe-web/cafe2/ArticleListV2dot1.json?"
        "search.clubid=$url"
        "&search.queryType=lastArticle"
        "&search.perPage=20"
        "&ad=false"
        "&uuid=6dd62de1-7279-49f0-b009-6ccc554ac679"
        "&search.page=$page";
  }

  @override
  String urlBySearchList(
          String url, String board, int page, String keyword, LastId lastId) =>
      throw UnimplementedError('urlBySearchList');

  @override
  String urlByMain() =>
      'https://apis.naver.com/cafe-home-web/cafe-home/v1/cafes/join?perPage=100';

  @override
  String urlByComments(String url, String board, int id, int page) =>
      throw UnimplementedError();
}
