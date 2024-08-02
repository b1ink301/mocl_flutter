import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
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
    log('MainDataBloc event=$event');
    switch (event) {
      case GetMainDataEvent():
        emit(const MainDataState.initial());
        var result = await getMainList.call(event.siteType);
        if (result is ResultSuccess) {
          emit(MainDataState.success(result.data));
        } else if (result is ResultFailure) {
          emit(const MainDataState.failure("failure"));
        }
      case SetMainDataEvent():
        break;
    }
  }
}
