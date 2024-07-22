import 'dart:developer';

import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:mocl_flutter/features/mocl/data/datasources/parser/base_parser.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/mocl_result.dart';
import 'mocl_local_database.dart';

abstract class ListDataSource {
  Future<Result> getList(MainItem item, int page);

  Future<int> setReadFlag(
    SiteType siteType,
    int boardId,
  );

  Future<bool> isReadFlag(
    SiteType siteType,
    int boardId,
  );
}

class ListDataSourceImpl extends ListDataSource {
  final BaseParser parser;
  final LocalDatabase localDatabase;

  ListDataSourceImpl({required this.localDatabase, required this.parser});

  @override
  Future<Result> getList(MainItem item, int page) async {
    Future<bool> isRead(int id) async => isReadFlag(item.siteType, id);

    final url = Uri.parse("${item.url}?page=$page");
    log('getList = $url');
    // final headers = {
    //   'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:126.0) Gecko/20100101 Firefox/126.0',
    // };
    final response = await http.Client().get(url);
    log('getList response = ${response.statusCode}');
    if (response.statusCode == 200) {
      var document = parse(response.body);
      return await parser.list(document, -1, isRead);
    } else {
      return await Future<ResultFailure<Failure>>.value(
          ResultFailure(failure: GetListFailure()));
    }
  }

  @override
  Future<int> setReadFlag(
    SiteType siteType,
    int boardId,
  ) async =>
      localDatabase.setRead(siteType, boardId);

  @override
  Future<bool> isReadFlag(
    SiteType siteType,
    int boardId,
  ) async =>
      localDatabase.isRead(siteType, boardId);
}
