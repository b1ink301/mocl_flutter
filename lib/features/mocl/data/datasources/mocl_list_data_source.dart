import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:mocl_flutter/features/mocl/data/datasources/parser/base_parser.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/mocl_result.dart';

abstract class ListDataSource {
  Future<Result> getList(MainItem item, int page);
}

class ListDataSourceImpl extends ListDataSource {
  final BaseParser parser;

  ListDataSourceImpl({required this.parser});

  @override
  Future<Result> getList(MainItem item, int page) async {
    final url = Uri.parse("${item.url}?page=$page");
    print('getList = $url');
    // final headers = {
    //   'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:126.0) Gecko/20100101 Firefox/126.0',
    // };
    final response = await http.Client().get(url);
    print('getList response = ${response.statusCode}');
    if (response.statusCode == 200) {
      var document = parse(response.body);
      return await parser.list(document, -1);
    } else {
      return await Future<ResultFailure<Failure>>.value(
          ResultFailure(failure: GetListFailure()));
    }
  }
}
