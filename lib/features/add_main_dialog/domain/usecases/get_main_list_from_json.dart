import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/features/main_page/domain/repositories/main_repository.dart';

class const GetMainListFromJson({required final MainRepository mainRepository})
    implements FutureUseCase<Either<Failure, List<MainItem>>, SiteType> {
  @override
  Future<Either<Failure, List<MainItem>>> call(SiteType params) =>
      mainRepository.getMainListFromJson(siteType: params);
}
