import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/last_id.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/sort_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_search_list.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/use_case_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/providers/list_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'list_search_proivders.g.dart';

@riverpod
class KeywordNotifier extends _$KeywordNotifier {
  @override
  String build() => '';

  void setKeyword(String keyword) {
    state = keyword;
  }
}

@Riverpod(dependencies: [mainItem, KeywordNotifier])
Future<Either<Failure, List<ListItem>>> reqSearchListData(Ref ref) async {
  final MainItem mainItem = ref.watch(mainItemProvider);
  final SortType sortType = ref.watch(sortTypeNotifierProvider);
  final String keyword = ref.watch(keywordNotifierProvider);

  if (keyword.isEmpty) {
    return Right(List.empty());
  }

  final GetSearchListParams params = GetSearchListParams(
      mainItem: mainItem,
      page: 0,
      lastId: LastId.empty(),
      sortType: sortType,
      keyword: keyword);

  return await ref.read(getSearchListProvider)(params);
}
