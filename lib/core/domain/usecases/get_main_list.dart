import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/domain/repositories/main_repository.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';

@injectable
class GetMainList implements UseCase<Future<Result<List<MainItem>>>, SiteType> {
  final MainRepository mainRepository;

  const GetMainList({required this.mainRepository});

  @override
  Future<Result<List<MainItem>>> call(
    SiteType params,
  ) =>
      mainRepository.getMainList(siteType: params);
}
