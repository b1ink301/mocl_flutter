import 'package:equatable/equatable.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/features/detail_page/domain/repositories/detail_repository.dart';

class const SetReadFlag({required final DetailRepository detailRepository})
    implements UseCase<Future<int>, SetReadFlagParams> {
  @override
  Future<int> call(SetReadFlagParams params) => detailRepository.setReadFlag(
    siteType: params.siteType,
    boardId: params.boardId,
    replyCount: params.replyCount,
    alreadyRead: params.alreadyRead,
  );
}

class const SetReadFlagParams({
  required final SiteType siteType,
  required final int boardId,

  /// 이번에 본 댓글 수. 모르면 null(남기지 않는다).
  final int? replyCount,

  /// 이미 읽은 글이면 읽음 기록은 두고 댓글 수만 남긴다.
  final bool alreadyRead = false,
}) extends Equatable {
  @override
  List<Object?> get props => [siteType, boardId, replyCount, alreadyRead];
}
