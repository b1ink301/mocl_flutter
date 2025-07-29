part of 'main_data_bloc.dart';

@freezed
sealed class MainDataEvent with _$MainDataEvent {
  const factory MainDataEvent.getList({required SiteType siteType}) =
      GetListEvent;
}
