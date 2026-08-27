import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/features/detail_page/domain/repositories/detail_repository.dart';

class const GetDetail({required final DetailRepository detailRepository})
    implements UseCase<Future<Either<Failure, Details>>, ListItem> {
  @override
  Future<Either<Failure, Details>> call(ListItem params) =>
      detailRepository.getDetail(item: params);
}
