part of 'main_data_bloc.dart';

@freezed
sealed class MainDataState with _$MainDataState {
  const factory MainDataState.initial() = StateInitial;

  const factory MainDataState.loading() = StateLoading;

  const factory MainDataState.success(List<MainItem> data) = StateSuccess;

  const factory MainDataState.failure(String message) = StateFailure;

  const factory MainDataState.requireLogin(String message) = StateRequireLogin; //
}
