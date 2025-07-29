import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/domain/repositories/main_repository.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';

@injectable
class GetMainListFromJson implements UseCase<Future<Result>, SiteType> {
  final MainRepository mainRepository;

  const GetMainListFromJson({required this.mainRepository});

  @override
  Future<Result> call(SiteType params) =>
      mainRepository.getMainListFromJson(siteType: params);
}
