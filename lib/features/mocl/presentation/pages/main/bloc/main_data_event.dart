part of 'main_data_bloc.dart';

@freezed
abstract class MainDataEvent with _$MainDataEvent {
  const factory MainDataEvent.getList({required SiteType siteType}) =
      GetListEvent;

  const factory MainDataEvent.setSiteType({required SiteType siteType}) =
      SetSiteTypeEvent;

  const factory MainDataEvent.getSiteType() = GetSiteTypeEvent;

  const factory MainDataEvent.setList(SiteType siteType, List<MainItem> list) =
      SetListEvent;
}
