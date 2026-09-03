// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(favoriteRepository)
final favoriteRepositoryProvider = FavoriteRepositoryProvider._();

final class FavoriteRepositoryProvider
    extends
        $FunctionalProvider<
          FavoriteRepository,
          FavoriteRepository,
          FavoriteRepository
        >
    with $Provider<FavoriteRepository> {
  FavoriteRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoriteRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoriteRepositoryHash();

  @$internal
  @override
  $ProviderElement<FavoriteRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FavoriteRepository create(Ref ref) {
    return favoriteRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FavoriteRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FavoriteRepository>(value),
    );
  }
}

String _$favoriteRepositoryHash() =>
    r'2dad519ba7f5abc1a266d529b35070e9df56834d';

/// 즐겨찾기 그룹(카테고리) 목록. 최초에는 사이트 카테고리 기반 기본 그룹이 시드된다.

@ProviderFor(FavoriteGroupsNotifier)
final favoriteGroupsProvider = FavoriteGroupsNotifierProvider._();

/// 즐겨찾기 그룹(카테고리) 목록. 최초에는 사이트 카테고리 기반 기본 그룹이 시드된다.
final class FavoriteGroupsNotifierProvider
    extends
        $AsyncNotifierProvider<FavoriteGroupsNotifier, List<FavoriteGroup>> {
  /// 즐겨찾기 그룹(카테고리) 목록. 최초에는 사이트 카테고리 기반 기본 그룹이 시드된다.
  FavoriteGroupsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoriteGroupsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoriteGroupsNotifierHash();

  @$internal
  @override
  FavoriteGroupsNotifier create() => FavoriteGroupsNotifier();
}

String _$favoriteGroupsNotifierHash() =>
    r'077eb8a121fd72fc3050b7b86e1dc3b82fc79381';

/// 즐겨찾기 그룹(카테고리) 목록. 최초에는 사이트 카테고리 기반 기본 그룹이 시드된다.

abstract class _$FavoriteGroupsNotifier
    extends $AsyncNotifier<List<FavoriteGroup>> {
  FutureOr<List<FavoriteGroup>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<FavoriteGroup>>, List<FavoriteGroup>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<FavoriteGroup>>, List<FavoriteGroup>>,
              AsyncValue<List<FavoriteGroup>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// 즐겨찾기한 게시판 전체. 메인 화면의 유일한 데이터 소스다.

@ProviderFor(FavoritesNotifier)
final favoritesProvider = FavoritesNotifierProvider._();

/// 즐겨찾기한 게시판 전체. 메인 화면의 유일한 데이터 소스다.
final class FavoritesNotifierProvider
    extends $AsyncNotifierProvider<FavoritesNotifier, List<FavoriteData>> {
  /// 즐겨찾기한 게시판 전체. 메인 화면의 유일한 데이터 소스다.
  FavoritesNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoritesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoritesNotifierHash();

  @$internal
  @override
  FavoritesNotifier create() => FavoritesNotifier();
}

String _$favoritesNotifierHash() => r'314a2a346d3d515b3c140da9ad7a2a4ef773ca5b';

/// 즐겨찾기한 게시판 전체. 메인 화면의 유일한 데이터 소스다.

abstract class _$FavoritesNotifier extends $AsyncNotifier<List<FavoriteData>> {
  FutureOr<List<FavoriteData>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<FavoriteData>>, List<FavoriteData>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<FavoriteData>>, List<FavoriteData>>,
              AsyncValue<List<FavoriteData>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// 그룹 순서대로 묶은 메인 화면용 섹션 목록.
/// 그룹이 삭제되는 등으로 소속을 잃은 항목은 사이트 기본 카테고리로,
/// 그마저 없으면 첫 그룹으로 보내 화면에서 사라지지 않게 한다.

@ProviderFor(favoriteSections)
final favoriteSectionsProvider = FavoriteSectionsProvider._();

/// 그룹 순서대로 묶은 메인 화면용 섹션 목록.
/// 그룹이 삭제되는 등으로 소속을 잃은 항목은 사이트 기본 카테고리로,
/// 그마저 없으면 첫 그룹으로 보내 화면에서 사라지지 않게 한다.

final class FavoriteSectionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<FavoriteSection>>,
          List<FavoriteSection>,
          FutureOr<List<FavoriteSection>>
        >
    with
        $FutureModifier<List<FavoriteSection>>,
        $FutureProvider<List<FavoriteSection>> {
  /// 그룹 순서대로 묶은 메인 화면용 섹션 목록.
  /// 그룹이 삭제되는 등으로 소속을 잃은 항목은 사이트 기본 카테고리로,
  /// 그마저 없으면 첫 그룹으로 보내 화면에서 사라지지 않게 한다.
  FavoriteSectionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoriteSectionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoriteSectionsHash();

  @$internal
  @override
  $FutureProviderElement<List<FavoriteSection>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<FavoriteSection>> create(Ref ref) {
    return favoriteSections(ref);
  }
}

String _$favoriteSectionsHash() => r'211fe713068f7cbea846b5be6569a0c18b8ef505';
