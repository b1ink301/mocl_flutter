part of 'detail_view_bloc.dart';

@freezed
sealed class DetailViewEvent with _$DetailViewEvent {
  const factory DetailViewEvent.details() = DetailsEvent;
}
