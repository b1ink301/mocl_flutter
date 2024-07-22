import 'package:isar/isar.dart';

import '../../domain/entities/mocl_site_type.dart';

part 'mocl_read_item_entity.g.dart';

@collection
@Name("ReadList")
class ReadItemEntity {
  Id id = Isar.autoIncrement;
  @Index(unique: true)
  late int boardId;

  @Index()
  @Enumerated(EnumType.name)
  late SiteType siteType;

  ReadItemEntity();
}