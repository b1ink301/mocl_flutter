import 'package:equatable/equatable.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/features/list_page/domain/repositories/list_repository.dart';

class const GetReadFlag({required final ListRepository listRepository})
    implements UseCase<Future<bool>, GetReadFlagParams> {
  @override
  Future<bool> call(GetReadFlagParams params) => listRepository.getReadFlag(
    siteType: params.siteType,
    boardId: params.boardId,
  );
}

class const GetReadFlagParams({
  required final SiteType siteType,
  required final int boardId,
}) extends Equatable {
  @override
  List<Object> get props => [siteType, boardId];
}
