part of 'settings_bloc.dart';

@freezed
abstract class SettingsEvent with _$SettingsEvent {
  const factory SettingsEvent.getVersion() = GetVersionEvent;

  const factory SettingsEvent.clearData() = ClearDataEvent;
}
