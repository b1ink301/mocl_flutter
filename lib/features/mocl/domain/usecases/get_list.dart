import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';

import '../entities/mocl_result.dart';
import '../repositories/list_repository.dart';

@injectable
class GetList extends UseCase<Future<Result>, GetListParams> {
  final ListRepository listRepository;

  GetList({required this.listRepository});

  @override
  Future<Result> call(
    GetListParams params,
  ) =>
      listRepository.getList(
        item: params.mainItem,
        page: params.page,
        lastId: params.lastId,
      );
}

class GetListParams extends Equatable {
  final MainItem mainItem;
  final int page;
  final int lastId;

  const GetListParams({
    required this.mainItem,
    required this.page,
    required this.lastId,
  });

  @override
  List<Object> get props => [mainItem, page, lastId];
}
