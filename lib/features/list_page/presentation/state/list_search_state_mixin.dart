import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/core/error/failures.dart';

import '../../application/list_search_proivders.dart';

mixin class ListSearchState {
  AsyncValue<Either<Failure, List<ListItem>>> listState(WidgetRef ref) =>
      ref.watch(reqSearchListDataProvider);
}
