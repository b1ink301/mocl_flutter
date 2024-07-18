import 'package:equatable/equatable.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';

import '../entities/mocl_result.dart';
import '../repositories/main_repository.dart';

class GetMainList extends UseCase<List<MainItem>, GetMainParams> {
  final MainRepository mainRepository;

  GetMainList({required this.mainRepository});

  @override
  Future<Result> call(
    GetMainParams params,
  ) async => await mainRepository.getMainList(siteType: params.siteType);
}

class GetMainParams extends Equatable {
  final SiteType siteType;

  const GetMainParams({required this.siteType});

  @override
  List<Object> get props => [siteType];
}
