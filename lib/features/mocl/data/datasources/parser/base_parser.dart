import 'package:html/dom.dart';

import '../../../domain/entities/mocl_list_item.dart';
import '../../../domain/entities/mocl_result.dart';

abstract class BaseParser {
  Future<Result> list(Document document, int lastIndex);
  Future<Result> detail(Document document);
  Future<Result> comment(Document document);
}