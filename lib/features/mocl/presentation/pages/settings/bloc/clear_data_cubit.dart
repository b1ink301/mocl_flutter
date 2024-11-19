import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'clear_data_state.dart';
part 'clear_data_cubit.freezed.dart';

@injectable
class ClearDataCubit extends Cubit<ClearDataState> {
  ClearDataCubit() : super(const ClearDataState.initial());
}
