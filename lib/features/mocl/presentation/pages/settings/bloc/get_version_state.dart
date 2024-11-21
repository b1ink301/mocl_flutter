part of 'get_version_cubit.dart';

@freezed
sealed class GetVersionState with _$GetVersionState {
  const factory GetVersionState.initial() = _Initial;
  const factory GetVersionState.loading() = _Loading;
  const factory GetVersionState.success(String version) = _Success;
}
