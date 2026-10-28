import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_comment_write.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/error/failures.dart';

abstract class DetailRepository() {
  Future<Either<Failure, Details>> getDetail({required ListItem item});

  Future<int> setReadFlag({required SiteType siteType, required int boardId});

  /// 이 사이트에서 앱으로 댓글을 쓸 수 있는지.
  bool get supportsCommentWrite;

  Future<Either<Failure, Unit>> writeComment(CommentWrite write);
}
