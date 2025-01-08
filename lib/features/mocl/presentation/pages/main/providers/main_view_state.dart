part of 'main_providers.dart';

@freezed
sealed class MainViewState with _$MainViewState {
  const factory MainViewState.initial() = _StateInitial;

  const factory MainViewState.loading() = _StateLoading;

  const factory MainViewState.success(List<MainItem> data, String title) = _StateSuccess;

  const factory MainViewState.failure(String message) = _StateFailure;
}
