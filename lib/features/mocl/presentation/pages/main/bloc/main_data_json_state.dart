part of 'main_data_json_bloc.dart';

@freezed
class MainDataJsonState with _$MainDataJsonState {
  const factory MainDataJsonState.initial() = StateInitial;

  const factory MainDataJsonState.loading() = StateLoading;

  const factory MainDataJsonState.success(List<MainItem> data) = StateSuccess;

  const factory MainDataJsonState.failure(String message) = StateFailure;
}