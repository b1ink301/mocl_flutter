import 'package:html/dom.dart';

import '../../../domain/entities/mocl_result.dart';

abstract class BaseParser {
  Future<Result> list(
    Document document,
    int lastIndex,
    String boardTitle,
    Future<bool> Function(int) isRead,
  );

  Future<Result> detail(Document document);

  Future<Result> comment(Document document);
}
