import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/last_id.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/sort_type.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/list_repository.dart';

class GetList
    implements UseCase<Future<Either<Failure, List<ListItem>>>, GetListParams> {
  final ListRepository listRepository;

  const GetList({required this.listRepository});

  @override
  Future<Either<Failure, List<ListItem>>> call(GetListParams params) =>
      listRepository.getList(
        item: params.mainItem,
        page: params.page,
        lastId: params.lastId,
        sortType: params.sortType,
      );
}

class GetListParams extends Equatable {
  final MainItem mainItem;
  final int page;
  final LastId lastId;
  final SortType sortType;

  const GetListParams({
    required this.mainItem,
    required this.page,
    required this.lastId,
    required this.sortType,
  });

  @override
  List<Object> get props => [mainItem, page, lastId, sortType];
}
