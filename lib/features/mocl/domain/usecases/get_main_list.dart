import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/main_repository.dart';

class GetMainList
    implements FutureUseCase<Either<Failure, List<MainItem>>, SiteType> {
  final MainRepository mainRepository;

  const GetMainList({required this.mainRepository});

  @override
  Future<Either<Failure, List<MainItem>>> call(SiteType params) =>
      mainRepository.getMainList(siteType: params);
}
