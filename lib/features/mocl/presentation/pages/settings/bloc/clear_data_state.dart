part of 'clear_data_cubit.dart';

@freezed
sealed class ClearDataState with _$ClearDataState {
  const factory ClearDataState.initial() = _Initial;
  const factory ClearDataState.loading() = _Loading;
  const factory ClearDataState.success() = _Success;
}
