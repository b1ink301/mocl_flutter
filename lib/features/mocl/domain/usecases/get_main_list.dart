import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';

import '../entities/mocl_result.dart';
import '../repositories/main_repository.dart';

class GetMainList extends FutureUseCase<Result, SiteType> {
  final MainRepository mainRepository;

  GetMainList({required this.mainRepository});

  @override
  Future<Result> call(
      SiteType params,
  ) async => await mainRepository.getMainList(siteType: params);
}
