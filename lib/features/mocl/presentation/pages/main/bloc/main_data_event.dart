part of 'main_data_bloc.dart';

@immutable
sealed class MainDataEvent {}

class GetMainDataEvent extends MainDataEvent {
  final SiteType siteType;

  GetMainDataEvent({required this.siteType});
}

class SetMainDataEvent extends MainDataEvent {
  final SiteType siteType;
  final List<MainItem> list;

  SetMainDataEvent({
    required this.siteType,
    required this.list,
  });
}
