import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/main_repository.dart';

class SetMainList
    extends UseCase<Future<Either<Failure, List<int>>>, SetMainParams> {
  final MainRepository mainRepository;

  SetMainList({required this.mainRepository});

  @override
  Future<Either<Failure, List<int>>> call(SetMainParams params) =>
      mainRepository.setMainList(
        siteType: params.siteType,
        list: params.list,
      );
}

class SetMainParams extends Equatable {
  final SiteType siteType;
  final List<MainItem> list;

  const SetMainParams({
    required this.siteType,
    required this.list,
  });

  @override
  List<Object> get props => [
        siteType,
        list,
      ];
}
