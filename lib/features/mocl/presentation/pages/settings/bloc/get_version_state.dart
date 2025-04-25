part of 'get_version_cubit.dart';

@freezed
sealed class GetVersionState with _$GetVersionState {
  const factory GetVersionState.initial() = InitialGetVersionState;
  const factory GetVersionState.loading() = LoadingGetVersionState;
  const factory GetVersionState.success(String version) = SuccessGetVersionState;
  const factory GetVersionState.failure(String errorMessage) = FailureGetVersionState;
}
