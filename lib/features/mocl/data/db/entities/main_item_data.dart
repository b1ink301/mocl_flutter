import 'package:floor/floor.dart';
import 'package:mocl_flutter/features/mocl/data/models/main_item_model.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';

import '../../models/model_mapper.dart';

@Entity(
  tableName: 'main',
  primaryKeys: ['board', 'siteType'],
)
class MainItemData {
  final String board;
  final int orderBy;
  final int type;
  final String text;
  final String url;
  final SiteType siteType;

  MainItemData({
    required this.board,
    required this.orderBy,
    required this.type,
    required this.text,
    required this.url,
    required this.siteType,
  });
}

extension MainItemDataExtention on MainItemData {
  MainItemModel toMainItemModel() => MainItemMapper.toModel(this);
}
