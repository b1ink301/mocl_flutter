part of 'clear_data_cubit.dart';

@freezed
sealed class ClearDataState with _$ClearDataState {
  const factory ClearDataState.initial() = InitialClearDataState;
  const factory ClearDataState.loading() = LoadingClearDataState;
  const factory ClearDataState.success() = SuccessClearDataState;
}
