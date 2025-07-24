import 'package:equatable/equatable.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/domain/repositories/list_repository.dart';

class SetReadFlag implements UseCase<Future<int>, SetReadFlagParams> {
  final ListRepository listRepository;

  const SetReadFlag({required this.listRepository});

  @override
  Future<int> call(SetReadFlagParams params) => listRepository.setReadFlag(
    siteType: params.siteType,
    boardId: params.boardId,
  );
}

class SetReadFlagParams extends Equatable {
  final SiteType siteType;
  final int boardId;

  const SetReadFlagParams({required this.siteType, required this.boardId});

  @override
  List<Object> get props => [siteType, boardId];
}
