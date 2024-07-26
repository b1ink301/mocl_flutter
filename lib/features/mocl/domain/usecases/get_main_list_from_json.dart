import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';

import '../repositories/main_repository.dart';

class GetMainListFromJson extends StreamUseCase<List<MainItem>, SiteType> {
  final MainRepository mainRepository;

  GetMainListFromJson({required this.mainRepository});

  @override
  Stream<Result> call(SiteType params) async* {
    yield* mainRepository.getMainListFromJson(siteType: params);
  }
}
