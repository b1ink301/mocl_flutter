import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/last_id.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/sort_type.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/list_repository.dart';

class GetSearchList
    implements
        UseCase<Future<Either<Failure, List<ListItem>>>, GetSearchListParams> {
  final ListRepository listRepository;

  const GetSearchList({required this.listRepository});

  @override
  Future<Either<Failure, List<ListItem>>> call(
    GetSearchListParams params,
  ) =>
      listRepository.getSearchList(
        item: params.mainItem,
        page: params.page,
        lastId: params.lastId,
        sortType: params.sortType,
        keyword: params.keyword,
      );
}

class GetSearchListParams extends Equatable {
  final MainItem mainItem;
  final int page;
  final LastId lastId;
  final SortType sortType;
  final String keyword;

  const GetSearchListParams({
    required this.mainItem,
    required this.page,
    required this.lastId,
    required this.sortType,
    required this.keyword,
  });

  @override
  List<Object> get props => [mainItem, page, lastId, sortType, keyword];
}
