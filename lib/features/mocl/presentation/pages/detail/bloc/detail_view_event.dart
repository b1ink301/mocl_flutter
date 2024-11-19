part of 'detail_view_bloc.dart';

@freezed
class DetailViewEvent with _$DetailViewEvent {
  const factory DetailViewEvent.details() = DetailsEvent;
}
