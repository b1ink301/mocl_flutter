part of 'main_view_model.dart';

@freezed
sealed class MainState with _$MainState {
  const factory MainState.initial() = MainStateInitial;

  const factory MainState.loading() = MainStateLoading;

  const factory MainState.success(List<MainItem> data) = MainStateSuccess;

  const factory MainState.failure(String message) = MainStateFailure;
}
