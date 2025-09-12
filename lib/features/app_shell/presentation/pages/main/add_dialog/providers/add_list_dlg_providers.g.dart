// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_list_dlg_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AddListDlgNotifier)
const addListDlgProvider = AddListDlgNotifierProvider._();

final class AddListDlgNotifierProvider
    extends
        $AsyncNotifierProvider<AddListDlgNotifier, List<CheckableMainItem>> {
  const AddListDlgNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addListDlgProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addListDlgNotifierHash();

  @$internal
  @override
  AddListDlgNotifier create() => AddListDlgNotifier();
}

String _$addListDlgNotifierHash() =>
    r'385972035378bd160bddb4cc98c64ba3578a6648';

abstract class _$AddListDlgNotifier
    extends $AsyncNotifier<List<CheckableMainItem>> {
  FutureOr<List<CheckableMainItem>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<CheckableMainItem>>,
              List<CheckableMainItem>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<CheckableMainItem>>,
                List<CheckableMainItem>
              >,
              AsyncValue<List<CheckableMainItem>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
