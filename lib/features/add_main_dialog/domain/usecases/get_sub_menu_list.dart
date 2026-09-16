import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/features/main_page/domain/repositories/main_repository.dart';

/// 컨테이너(네이버 카페 등) 안의 하위 게시판 목록을 가져온다.
class const GetSubMenuList({required final MainRepository mainRepository})
    implements FutureUseCase<Either<Failure, List<MainItem>>, MainItem> {
  @override
  Future<Either<Failure, List<MainItem>>> call(MainItem params) =>
      mainRepository.getSubMenuList(parent: params);
}
