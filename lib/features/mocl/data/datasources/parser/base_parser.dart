import 'package:html/dom.dart';

import '../../../domain/entities/mocl_result.dart';
import '../../../domain/entities/mocl_site_type.dart';

abstract class BaseParser {
  Future<Result> list(
    Document document,
    int lastIndex,
    Future<bool> Function(int) isRead,
  );

  Future<Result> detail(Document document);

  Future<Result> comment(Document document);
}
