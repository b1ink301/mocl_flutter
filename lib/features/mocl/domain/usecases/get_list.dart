import 'package:equatable/equatable.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';

import '../entities/mocl_result.dart';
import '../repositories/list_repository.dart';

class GetList extends UseCase<List<MainItem>, GetListParams> {
  final ListRepository listRepository;

  GetList({required this.listRepository});

  @override
  Future<Result> call(
    GetListParams params,
  ) async =>
      listRepository.getList(
        item: params.mainItem,
        page: params.page,
      );
}

class GetListParams extends Equatable {
  final MainItem mainItem;
  final int page;

  const GetListParams({
    required this.mainItem,
    required this.page,
  });

  @override
  List<Object> get props => [mainItem, page];
}
