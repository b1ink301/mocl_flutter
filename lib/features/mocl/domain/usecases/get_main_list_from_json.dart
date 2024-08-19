import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';

import '../repositories/main_repository.dart';

@injectable
class GetMainListFromJson extends UseCase<Future<Result>, SiteType> {
  final MainRepository mainRepository;

  GetMainListFromJson({required this.mainRepository});

  @override
  Future<Result> call(SiteType params) =>
      mainRepository.getMainListFromJson(siteType: params);
}
