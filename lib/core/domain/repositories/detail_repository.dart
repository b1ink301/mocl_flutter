import 'package:mocl_flutter/core/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_result.dart';

abstract class DetailRepository {
  Future<Result<Details>> getDetail({
    required ListItem item,
  });
}
