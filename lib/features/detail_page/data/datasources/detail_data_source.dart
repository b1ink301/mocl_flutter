import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_comment_write.dart';
import 'package:mocl_shared/entities/mocl_details.dart';
import 'package:mocl_shared/entities/mocl_list_item.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/database/data/datasources/local/local_database.dart';
import 'package:mocl_shared/parser/base/base_parser.dart';
import 'package:mocl_flutter/features/network/data/datasources/base_api.dart';

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
}) implements DetailDataSource {
  @override
  Future<Either<Failure, Details>> getDetail(ListItem item) =>
      apiClient.detail(item, parser);

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
