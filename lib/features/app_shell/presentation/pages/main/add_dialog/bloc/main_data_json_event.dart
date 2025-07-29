part of 'main_data_json_bloc.dart';

@freezed
sealed class MainDataJsonEvent with _$MainDataJsonEvent {
  const factory MainDataJsonEvent.getList({required SiteType siteType}) =
      GetListEvent;

  const factory MainDataJsonEvent.addList({
    required SiteType siteType,
    required final List<MainItem> list,
  }) = AddListEvent;
}
