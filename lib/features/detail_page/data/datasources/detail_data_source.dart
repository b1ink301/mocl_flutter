import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_comment_write.dart';
import 'package:mocl_shared/entities/mocl_details.dart';
import 'package:mocl_shared/entities/mocl_list_item.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/database/data/datasources/local/local_database.dart';
import 'package:mocl_shared/parser/base/base_parser.dart';
import 'package:mocl_flutter/features/network/data/datasources/base_api.dart';
import 'package:mocl_flutter/features/site_health/data/site_health_reporter.dart';

abstract class DetailDataSource() {
  Future<Either<Failure, Details>> getDetail(ListItem item);

  Future<int> setReadFlag(
    SiteType siteType,
    int id, {
    int? replyCount,
    bool alreadyRead = false,
  });

  bool get supportsCommentWrite;

  Future<Either<Failure, Unit>> writeComment(CommentWrite write);
}

class const DetailDataSourceImpl({
  required final BaseApi apiClient,
  required final BaseParser parser,
  required final LocalDatabase localDatabase,

  /// 파서 고장을 스스로 알린다.
  final SiteHealthReporter? health,
}) implements DetailDataSource {
  @override
  Future<Either<Failure, Details>> getDetail(ListItem item) async {
    final Either<Failure, Details> result = await apiClient.detail(
      item,
      parser,
    );
    health?.onDetail(parser.siteType, item, result);
    return result;
  }

  @override
  Future<int> setReadFlag(
    SiteType siteType,
    int id, {
    int? replyCount,
    bool alreadyRead = false,
  }) async {
    if (!alreadyRead) {
      return localDatabase.setRead(siteType, id, replyCount: replyCount);
    }
    if (replyCount != null) {
      await localDatabase.setSeenReplies(siteType, id, replyCount);
    }
    return id;
  }

  @override
  bool get supportsCommentWrite => apiClient.supportsCommentWrite;

  @override
  Future<Either<Failure, Unit>> writeComment(CommentWrite write) =>
      apiClient.writeComment(write, parser);
}
