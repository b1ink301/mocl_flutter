part of 'get_height_cubit.dart';

@freezed
sealed class GetHeightState with _$GetHeightState {
  const factory GetHeightState.initial() = InitialGetHeightState;
  const factory GetHeightState.success(double height) = SuccessGetHeightState;
}
