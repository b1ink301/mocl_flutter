import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';

import '../entities/mocl_result.dart';

abstract class DetailRepository {
  Future<Result> getDetail({
    required ListItem item,
  });
}
