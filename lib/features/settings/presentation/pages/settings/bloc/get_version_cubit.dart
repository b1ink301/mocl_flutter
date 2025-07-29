import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'get_version_state.dart';

part 'get_version_cubit.freezed.dart';

@injectable
class GetVersionCubit extends Cubit<GetVersionState> {
  GetVersionCubit() : super(const GetVersionState.initial()) {
    _getVersion();
  }

  Future<void> _getVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final version = 'v${info.version}-${info.buildNumber}';
      emit(GetVersionState.success(version));
    } catch (e) {
      emit(GetVersionState.failure(e.toString()));
    }
  }
}
