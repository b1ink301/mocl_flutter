import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/error/failures.dart';

abstract class DetailRepository {
  Future<Either<Failure, Details>> getDetail({required ListItem item});

  Future<int> setReadFlag({required SiteType siteType, required int boardId});
}
