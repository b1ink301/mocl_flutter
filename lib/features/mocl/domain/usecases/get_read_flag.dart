import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/list_repository.dart';

@injectable
class GetReadFlag implements UseCase<Future<bool>, SetReadFlagParams> {
  final ListRepository listRepository;

  const GetReadFlag({required this.listRepository});

  @override
  Future<bool> call(SetReadFlagParams params) => listRepository.getReadFlag(
        siteType: params.siteType,
        boardId: params.boardId,
      );
}

class SetReadFlagParams extends Equatable {
  final SiteType siteType;
  final int boardId;

  const SetReadFlagParams({
    required this.siteType,
    required this.boardId,
  });

  @override
  List<Object> get props => [
        siteType,
        boardId,
      ];
}
