import 'package:equatable/equatable.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/features/detail_page/domain/repositories/detail_repository.dart';

class const SetReadFlag({required final DetailRepository detailRepository})
    implements UseCase<Future<int>, SetReadFlagParams> {
  @override
  Future<int> call(SetReadFlagParams params) => detailRepository.setReadFlag(
    siteType: params.siteType,
    boardId: params.boardId,
  );
}

class const SetReadFlagParams({
  required final SiteType siteType,
  required final int boardId,
}) extends Equatable {
  @override
  List<Object> get props => [siteType, boardId];
}
