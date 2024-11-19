import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'get_version_state.dart';

part 'get_version_cubit.freezed.dart';

@injectable
class GetVersionCubit extends Cubit<GetVersionState> {
  GetVersionCubit() : super(const GetVersionState.initial());

  Future<void> getVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final version = 'v${info.version}-${info.buildNumber}';
      emit(GetVersionState.success(version));
    } catch (e) {
      final version = 'v1.0.0-error';
      emit(GetVersionState.success(version));
    }
  }
}
