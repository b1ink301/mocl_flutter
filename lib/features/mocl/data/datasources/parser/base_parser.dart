import 'package:dio/dio.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';

import '../../../domain/entities/mocl_result.dart';

abstract class BaseParser {
  late final SiteType siteType;

  Future<Result> list(
    Response response,
    int lastId,
    String boardTitle,
    Future<bool> Function(SiteType, int) isRead,
  );

  Future<Result> detail(Response response);

  Future<Result> comment(Response response);
}
