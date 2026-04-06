import 'package:equatable/equatable.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/features/detail_page/domain/repositories/detail_repository.dart';

class SetReadFlag implements UseCase<Future<int>, SetReadFlagParams> {
  final DetailRepository detailRepository;

  const SetReadFlag({required this.detailRepository});

  @override
  Future<int> call(SetReadFlagParams params) => detailRepository.setReadFlag(
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
