import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/detail_repository.dart';

import '../entities/mocl_result.dart';

class GetDetail extends UseCase<Future<Result>, ListItem> {
  final DetailRepository detailRepository;

  GetDetail({required this.detailRepository});

  @override
  Future<Result> call(ListItem params) =>
      detailRepository.getDetail(item: params);
}
