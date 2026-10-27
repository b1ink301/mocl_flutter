import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/domain/entities/last_id.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/sort_type.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/features/list_page/domain/repositories/list_repository.dart';

class const GetList({required final ListRepository listRepository})
    implements UseCase<Future<Either<Failure, List<ListItem>>>, GetListParams> {
  @override
  Future<Either<Failure, List<ListItem>>> call(GetListParams params) =>
      listRepository.getList(
        item: params.mainItem,
        page: params.page,
        lastId: params.lastId,
        sortType: params.sortType,
      );
}

class const GetListParams({
  required final MainItem mainItem,
  required final int page,
  required final LastId lastId,
  required final SortType sortType,
}) extends Equatable {
  @override
  List<Object> get props => [mainItem, page, lastId, sortType];
}
