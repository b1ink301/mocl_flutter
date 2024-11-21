import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/main_repository.dart';

@injectable
class GetMainList extends UseCase<Future<Result<List<MainItem>>>, SiteType> {
  final MainRepository mainRepository;

  GetMainList({required this.mainRepository});

  @override
  Future<Result<List<MainItem>>> call(
    SiteType params,
  ) =>
      mainRepository.getMainList(siteType: params);
}
