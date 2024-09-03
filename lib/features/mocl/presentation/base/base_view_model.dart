import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class BaseViewModel extends ChangeNotifier {

}

abstract class BaseStateViewModel<T> extends StateNotifier<T> {
  BaseStateViewModel(super.state);
}