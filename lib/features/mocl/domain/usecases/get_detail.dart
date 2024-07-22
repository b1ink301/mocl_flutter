import 'package:equatable/equatable.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/detail_repository.dart';

import '../entities/mocl_result.dart';

class GetDetail extends UseCase<List<MainItem>, GetDetailParams> {
  final DetailRepository detailRepository;

  GetDetail({required this.detailRepository});

  @override
  Future<Result> call(
      GetDetailParams params,
  ) async =>
      detailRepository.getDetail(item: params.item);
}

class GetDetailParams extends Equatable {
  final ListItem item;

  const GetDetailParams({
    required this.item,
  });

  @override
  List<Object> get props => [item];
}
