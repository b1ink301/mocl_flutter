import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/mocl/presentation/base/base_view_model.dart';

abstract class BaseStatelessView<V extends BaseViewModel>
    extends StatelessWidget {
  const BaseStatelessView({super.key});

  abstract final ProviderBase<V> viewModelProvider;
}
