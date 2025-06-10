import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class BaseViewModel extends Notifier {}

// abstract class BaseStateViewModel<STATE, SIDE_EFFECT> extends StateNotifier<STATE> {
//   BaseStateViewModel(super.state);
abstract class BaseStateViewModel<STATE, SIDE_EFFECT> extends Notifier<STATE> {
  final AsyncValue<SIDE_EFFECT> _sideEffect = AsyncLoading();
  AsyncValue<SIDE_EFFECT> get sideEffect => _sideEffect;
}
