// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_list_dlg_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(AddListDlgNotifier)
const addListDlgNotifierProvider = AddListDlgNotifierProvider._();

final class AddListDlgNotifierProvider
    extends
        $AsyncNotifierProvider<AddListDlgNotifier, List<CheckableMainItem>> {
  const AddListDlgNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addListDlgNotifierProvider',
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
    r'62743c49d3b692256a31476f570010f4036a4064';

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

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
