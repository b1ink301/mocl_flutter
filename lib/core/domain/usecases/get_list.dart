import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/core/domain/entities/last_id.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/core/domain/entities/sort_type.dart';
import 'package:mocl_flutter/core/domain/repositories/list_repository.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';

@injectable
class GetList
    implements UseCase<Future<Result<List<ListItem>>>, GetListParams> {
  final ListRepository listRepository;

  const GetList({required this.listRepository});

  @override
  Future<Result<List<ListItem>>> call(
    GetListParams params,
  ) =>
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
