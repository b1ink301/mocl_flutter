import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';

import '../../domain/usecases/get_main_list.dart';
import '../../domain/usecases/set_main_list.dart';

part 'main_data_event.dart';

part 'main_data_state.dart';

class MainDataBloc extends Bloc<MainDataEvent, MainDataState> {
  late final GetMainList getMainList;
  late final SetMainList setMainList;

  MainDataBloc({
    required this.getMainList,
    required this.setMainList,
  }) : super(const MainDataState.initial()) {
    on<MainDataEvent>(_getMainDataEvent);
  }

  Future<void> _getMainDataEvent(
    MainDataEvent event,
    Emitter<MainDataState> emit,
  ) async {
    print('MainDataBloc event=$event');
    switch (event) {
      case GetMainDataEvent():

        emit(const MainDataState.initial());
        // var params = GetMainParams(siteType: event.siteType);
        // var result = await getMainList.call(params);
        // result.fold((failure) {
        //   print('GetMainDataEvent failure=$failure');
        //   emit(const MainDataState.failure("failure"));
        // }, (data) {
        //   print('MainDataBloc event=$data');
        //   emit(MainDataState.success(data));
        // });
        break;
      case SetMainDataEvent():
        break;
    }
  }
}
