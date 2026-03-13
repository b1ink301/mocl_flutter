// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_sync_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AutoSyncNotifier)
final autoSyncProvider = AutoSyncNotifierProvider._();

final class AutoSyncNotifierProvider
    extends $NotifierProvider<AutoSyncNotifier, SyncAction> {
  AutoSyncNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'autoSyncProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$autoSyncNotifierHash();

  @$internal
  @override
  AutoSyncNotifier create() => AutoSyncNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncAction value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncAction>(value),
    );
  }
}

String _$autoSyncNotifierHash() => r'21e6c0579c20d6f648a4c977016e47654a32ca20';

abstract class _$AutoSyncNotifier extends $Notifier<SyncAction> {
  SyncAction build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SyncAction, SyncAction>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SyncAction, SyncAction>,
              SyncAction,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
