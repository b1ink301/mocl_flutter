import 'dart:async';

import 'package:floor/floor.dart';
import 'package:mocl_flutter/features/mocl/data/db/dao/is_read_dao.dart';
import 'package:mocl_flutter/features/mocl/data/db/dao/main_dao.dart';
import 'package:mocl_flutter/features/mocl/data/db/entities/main_item_data.dart';
import 'package:mocl_flutter/features/mocl/data/db/entities/read_item_data.dart';
import 'package:mocl_flutter/features/mocl/data/db/type_converter.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
// ignore: depend_on_referenced_packages
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart';

@Database(
  version: 1,
  entities: [MainItemData, ReadItemData],
)
@TypeConverters([DateTimeConverter, SiteTypeConverter])
abstract class AppDatabase extends FloorDatabase {
  MainDao get mainDao;

  IsReadDao get isReadDao;
}
