part of 'get_height_cubit.dart';

@freezed
sealed class GetHeightState with _$GetHeightState {
  const factory GetHeightState.initial() = _Initial;
  const factory GetHeightState.success(double height) = _Success;
}
