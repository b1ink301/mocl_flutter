import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_comment_write.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/features/detail_page/domain/repositories/detail_repository.dart';

class const WriteComment({required final DetailRepository detailRepository})
    implements UseCase<Future<Either<Failure, Unit>>, CommentWrite> {
  @override
  Future<Either<Failure, Unit>> call(CommentWrite params) {
    final String content = params.content.trim();
    if (content.isEmpty) {
      return Future.value(
        const Left(WriteCommentFailure(message: '댓글 내용을 입력해 주세요.')),
      );
    }
    return detailRepository.writeComment(
      CommentWrite(
        item: params.item,
        details: params.details,
        content: content,
        parent: params.parent,
      ),
    );
  }
}
