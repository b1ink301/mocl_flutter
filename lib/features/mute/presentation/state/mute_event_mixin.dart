import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/database/domain/entities/mute_rule.dart';
import 'package:mocl_flutter/features/mute/application/mute_providers.dart';

mixin class MuteEvent {
  void addMuteRule(WidgetRef ref, MuteRule rule) =>
      ref.read(muteRulesProvider.notifier).add(rule);

  void removeMuteRule(WidgetRef ref, MuteRule rule) =>
      ref.read(muteRulesProvider.notifier).remove(rule);
}
