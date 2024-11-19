part of 'settings_bloc.dart';

@freezed
class SettingsState<T> with _$SettingsState {
  const factory SettingsState.initial() = StateInitial;
  const factory SettingsState.loading() = StateLoading;
  const factory SettingsState.success(T data) = StateSuccess;
  const factory SettingsState.failure(String message) = StateFailure;
}
