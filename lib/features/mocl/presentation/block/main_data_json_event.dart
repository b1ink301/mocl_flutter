part of 'main_data_json_bloc.dart';

sealed class MainDataJsonEvent extends Equatable {
  const MainDataJsonEvent();
}

class GetMainDataFromJsonEvent extends MainDataJsonEvent {
  final SiteType siteType;

  const GetMainDataFromJsonEvent({required this.siteType});

  @override
  List<Object?> get props => [siteType];
}

class AddMainDataEvent extends MainDataJsonEvent {
  final SiteType siteType;
  final List<MainItem> list;

  const AddMainDataEvent({
    required this.siteType,
    required this.list,
  });

  @override
  List<Object?> get props => [siteType, list];
}