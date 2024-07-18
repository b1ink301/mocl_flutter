import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';

import '../repositories/main_repository.dart';
import 'get_main_list.dart';

class GetMainListFromJson extends StreamUseCase<List<MainItem>, GetMainParams> {
  final MainRepository mainRepository;

  GetMainListFromJson({required this.mainRepository});

  @override
  Stream<Result> call(GetMainParams params) async* {
    yield* mainRepository.getMainListFromJson(siteType: params.siteType);
  }
}
