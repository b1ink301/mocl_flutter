import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/error/failures.dart';

abstract class MainRepository() {
  /// 사이트가 제공하는 전체 게시판 후보 목록(게시판 선택 화면용).
  /// 사용자가 고른 게시판은 즐겨찾기(favorites)에 저장된다.
  Future<Either<Failure, List<MainItem>>> getMainListFromJson({
    required SiteType siteType,
  });
}
