import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/database/domain/entities/mute_rule.dart';
import 'package:mocl_flutter/features/mute/application/mute_providers.dart';

mixin class MuteState() {
  AsyncValue<List<MuteRule>> muteRulesState(WidgetRef ref) =>
      ref.watch(muteRulesProvider);
}
