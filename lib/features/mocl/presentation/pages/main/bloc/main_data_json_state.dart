part of 'main_data_json_bloc.dart';

class MainDataJsonState extends MainDataState {
  const MainDataJsonState.success(super.data) : super.success();
  const MainDataJsonState.failure(super.message) : super.failure();
  const MainDataJsonState.loading() : super.loading();
  const MainDataJsonState.initial() : super.initial();
  // const MainDataJsonState({
  //   super.status,
  //   super.data,
  //   super.message,
  // });

  // @override
  // MainDataJsonState copyWith({
  //   MainDataStatus? status,
  //   List<MainItem>? data,
  //   String? message,
  // }) => MainDataJsonState(
  //   status: status ?? this.status,
  //   data: data ?? this.data,
  //   message: message ?? this.message,
  // );
}