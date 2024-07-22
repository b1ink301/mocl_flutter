import 'package:equatable/equatable.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/list_repository.dart';

import '../../../../core/usecases/usecase.dart';
import '../entities/mocl_site_type.dart';

class SetReadFlag extends UseCase<int, SetReadFlagParams> {
  final ListRepository listRepository;

  SetReadFlag({required this.listRepository});

  @override
  Future<Result> call(SetReadFlagParams params) async {
    var result = await listRepository.setReadFlag(
      siteType: params.siteType,
      boardId: params.boardId,
    );
    return ResultSuccess(data: result);
  }
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
