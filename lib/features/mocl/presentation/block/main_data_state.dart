part of 'main_data_bloc.dart';

enum MainDataStatus { initial, loading, success, failure }

@immutable
class MainDataState extends Equatable {
  final MainDataStatus status;
  final List<MainItem> data;
  final String? message;

  const MainDataState._({
    this.status = MainDataStatus.initial,
    this.data = const [],
    this.message,
  });

  const MainDataState.failure(String message)
      : this._(
          status: MainDataStatus.failure,
          message: message,
        );

  const MainDataState.initial() : this._(status: MainDataStatus.initial);

  const MainDataState.loading() : this._(status: MainDataStatus.loading);

  const MainDataState.success(List<MainItem> data)
      : this._(status: MainDataStatus.success, data: data);

  @override
  List<Object?> get props => [status, data, message];
}
