import 'package:mocl_flutter/features/mocl/data/datasources/remote/base/base_parser.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/last_id.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_comment_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/sort_type.dart';

mixin BaseAction {
  Future<Result<List<MainItem>>> main(BaseParser parser);

  Future<Result<Details>> detail(ListItem item, BaseParser parser);

  Future<Result<List<ListItem>>> list(
    MainItem item,
    int page,
    LastId lastId,
    SortType sortType,
    BaseParser parser,
    Future<List<int>> Function(SiteType, List<int>) isReads,
  );

  Future<Result<List<ListItem>>> searchList(
    MainItem item,
    int page,
    LastId lastId,
    SortType sortType,
    String keyword,
    BaseParser parser,
    Future<List<int>> Function(SiteType, List<int>) isReads,
  );

  Future<Result<List<CommentItem>>> comments(
      ListItem item, BaseParser parser, int page);
}
