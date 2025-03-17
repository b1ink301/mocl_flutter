import 'package:equatable/equatable.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/list_repository.dart';

class GetReadFlag implements UseCase<Future<bool>, GetReadFlagParams> {
  final ListRepository listRepository;

  const GetReadFlag({required this.listRepository});

  @override
  Future<bool> call(GetReadFlagParams params) => listRepository.getReadFlag(
        siteType: params.siteType,
        boardId: params.boardId,
      );
}

class GetReadFlagParams extends Equatable {
  final SiteType siteType;
  final int boardId;

  const GetReadFlagParams({
    required this.siteType,
    required this.boardId,
  });

  @override
  List<Object> get props => [
        siteType,
        boardId,
      ];
}
