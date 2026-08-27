import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/features/main_page/domain/repositories/main_repository.dart';

class const SetMainList({required final MainRepository mainRepository})
    implements UseCase<Future<Either<Failure, List<int>>>, SetMainParams> {
  @override
  Future<Either<Failure, List<int>>> call(SetMainParams params) =>
      mainRepository.setMainList(siteType: params.siteType, list: params.list);
}

class const SetMainParams({
  required final SiteType siteType,
  required final List<MainItem> list,
}) extends Equatable {
  @override
  List<Object> get props => [siteType, list];
}
