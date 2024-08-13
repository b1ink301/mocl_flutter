import 'package:floor/floor.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';

class DateTimeConverter extends TypeConverter<DateTime, int> {
  @override
  DateTime decode(int databaseValue) =>
      DateTime.fromMillisecondsSinceEpoch(databaseValue);

  @override
  int encode(DateTime value) => value.millisecondsSinceEpoch;
}

class SiteTypeConverter extends TypeConverter<SiteType?, String?> {
  @override
  SiteType? decode(String? databaseValue) =>
      databaseValue == null ? null : SiteType.values.byName(databaseValue);

  @override
  String? encode(SiteType? value) => value?.name;
}
