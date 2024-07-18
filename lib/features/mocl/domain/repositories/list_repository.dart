import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';

import '../entities/mocl_result.dart';

abstract class ListRepository {
  Future<Result> getList({
    required MainItem item,
    required int page,
  });
}
