part of 'detail_view_bloc.dart';

@freezed
class DetailViewState with _$DetailViewState {
  const factory DetailViewState.loading() = DetailLoading;
  const factory DetailViewState.success(Details detail) = DetailSuccess;
  const factory DetailViewState.failed(String message) = DetailFailed;
}
