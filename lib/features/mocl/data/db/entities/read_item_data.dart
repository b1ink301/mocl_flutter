import 'package:floor/floor.dart';

import '../../../domain/entities/mocl_site_type.dart';

@Entity(
  tableName: 'is_read',
  primaryKeys: ['id', 'siteType'],
)
class ReadItemData {
  final int id;
  final SiteType siteType;

  ReadItemData({
    required this.id,
    required this.siteType,
  });
}
