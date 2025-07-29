import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'settings_bloc.freezed.dart';

part 'settings_event.dart';

part 'settings_state.dart';

@injectable
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const StateInitial()) {
    on<GetVersionEvent>(_onGetVersionEvent);
    on<ClearDataEvent>(_onClearDataEvent);
  }

  Future<void> _onGetVersionEvent(
    GetVersionEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(const StateLoading());
    await Future.delayed(Duration(seconds: 2));
    debugPrint('GetVersionEvent=$event, StateLoading');
    emit(const StateSuccess<String>('GetVersionEvent'));
  }

  Future<void> _onClearDataEvent(
    ClearDataEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(const StateLoading());
    await Future.delayed(Duration(seconds: 3));
    debugPrint('ClearDataEvent=$event, StateLoading');
    emit(const StateSuccess<String>('ClearDataEvent'));
  }
}
