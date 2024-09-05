import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_main_list_from_json.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/set_main_list.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/bloc/main_data_bloc.dart';

part 'main_data_json_event.dart';

part 'main_data_json_state.dart';

class MainDataJsonBloc extends Bloc<MainDataJsonEvent, MainDataJsonState> {
  late final GetMainListFromJson getMainListFromJson;
  late final SetMainList setMainList;

  final _mainStreamController = StreamController<MainDataState>.broadcast();

  Stream<MainDataState> get stateStream => _mainStreamController.stream;

  MainDataJsonBloc({
    required this.getMainListFromJson,
    required this.setMainList,
  }) : super(const MainDataJsonState.initial()) {
    on<MainDataJsonEvent>(_getMainDataJsonEvent);
  }

  Future<void> _getMainDataJsonEvent(
    MainDataJsonEvent event,
    Emitter<MainDataJsonState> emit,
  ) async {
    log('MainDataJsonBloc event=$event');
    switch (event) {
      case GetMainDataFromJsonEvent():
        emit(const MainDataJsonState.loading());
        _mainStreamController.add(const MainDataState.initial());
        var result = getMainListFromJson.call(event.siteType);
        // result.fold((failure) {
        //   print('GetMainDataFromJsonEvent failure=$failure');
        //   emit(MainDataJsonState.failure(failure.toString()));
        //   _mainStreamController.add(const MainDataState.failure("failure"));
        // }, (data) {
        //   emit(MainDataJsonState.success(data));
        //   _mainStreamController.add(MainDataState.success(data));
        // });
      case AddMainDataEvent():
        var params = SetMainParams(siteType: event.siteType, list: event.list);
        await setMainList(params);
        emit(const MainDataJsonState.initial());
        _mainStreamController.add(MainDataState.success(event.list));
    }
  }

  void dispose() {
    _mainStreamController.close();
  }
}
