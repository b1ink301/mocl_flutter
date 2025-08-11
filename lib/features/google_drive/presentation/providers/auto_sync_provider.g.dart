// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_sync_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(AutoSyncNotifier)
const autoSyncNotifierProvider = AutoSyncNotifierProvider._();

final class AutoSyncNotifierProvider
    extends $NotifierProvider<AutoSyncNotifier, SyncAction> {
  const AutoSyncNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'autoSyncNotifierProvider',
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

String _$autoSyncNotifierHash() => r'ff0790eff957621172f0573b26062bd026acf12b';

abstract class _$AutoSyncNotifier extends $Notifier<SyncAction> {
  SyncAction build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<SyncAction, SyncAction>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SyncAction, SyncAction>,
              SyncAction,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
