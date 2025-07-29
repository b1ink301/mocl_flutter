import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/domain/repositories/main_repository.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';

@injectable
class SetMainList implements UseCase<Future<void>, SetMainParams> {
  final MainRepository mainRepository;

  const SetMainList({required this.mainRepository});

  @override
  Future<Result> call(SetMainParams params) => mainRepository.setMainList(
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
