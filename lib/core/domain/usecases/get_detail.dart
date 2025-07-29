import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/core/domain/repositories/detail_repository.dart';

@injectable
class GetDetail implements UseCase<Future<Result<Details>>, ListItem> {
  final DetailRepository detailRepository;

  const GetDetail({required this.detailRepository});

  @override
  Future<Result<Details>> call(ListItem params) =>
      detailRepository.getDetail(item: params);
}
