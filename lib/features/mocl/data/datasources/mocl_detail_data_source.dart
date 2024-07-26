import 'package:flutter/foundation.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:mocl_flutter/features/mocl/data/datasources/parser/base_parser.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/mocl_result.dart';

abstract class DetailDataSource {
  Future<Result> getDetail(ListItem item);
}

class DetailDataSourceImpl extends DetailDataSource {
  final BaseParser parser;

  DetailDataSourceImpl({required this.parser});

  @override
  Future<Result> getDetail(ListItem item) async {
    final url = Uri.parse(item.url);
    debugPrint('getDetail = $url');
    final headers = {
      'User-Agent':
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:126.0) Gecko/20100101 Firefox/126.0',
    };
    final response = await http.Client().get(url, headers: headers);
    debugPrint('getDetail response = ${response.statusCode}');
    if (response.statusCode == 200) {
      var document = parse(response.body);
      return await parser.detail(document);
    } else {
      return await Future<ResultFailure<Failure>>.value(
          ResultFailure(failure: GetDetailFailure()));
    }
  }
}
