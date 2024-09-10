import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/main_repository.dart';

@injectable
class SetMainList extends UseCase<Future<void>, SetMainParams> {
  final MainRepository mainRepository;

  SetMainList({required this.mainRepository});

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
