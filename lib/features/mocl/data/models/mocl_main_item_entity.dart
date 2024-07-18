import 'package:isar/isar.dart';
import 'package:mocl_flutter/features/mocl/data/models/mocl_main_item_data.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'mocl_model_mapper.dart';

part 'mocl_main_item_entity.g.dart';

@collection
@Name("MainList")
class MainItemEntity {
  Id id = Isar.autoIncrement;
  late int orderBy;
  late int type;
  late String board;
  late String text;
  late String url;
  @Enumerated(EnumType.name)
  late SiteType siteType;

  MainItemEntity();
}

extension MainItemEntityExtention on MainItemEntity {
  MainItemData toMainItemModel() => MainItemMapper.toMainItemData(this);
}
