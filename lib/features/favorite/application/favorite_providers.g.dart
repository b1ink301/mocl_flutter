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

/// 즐겨찾기 게시판 목록(최근 추가순). 추가/삭제 시 invalidate 되어 갱신된다.

@ProviderFor(FavoritesNotifier)
final favoritesProvider = FavoritesNotifierProvider._();

/// 즐겨찾기 게시판 목록(최근 추가순). 추가/삭제 시 invalidate 되어 갱신된다.
final class FavoritesNotifierProvider
    extends $AsyncNotifierProvider<FavoritesNotifier, List<FavoriteData>> {
  /// 즐겨찾기 게시판 목록(최근 추가순). 추가/삭제 시 invalidate 되어 갱신된다.
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

String _$favoritesNotifierHash() => r'fd2a52e6368df93249609082102104d2f5a795a1';

/// 즐겨찾기 게시판 목록(최근 추가순). 추가/삭제 시 invalidate 되어 갱신된다.

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

/// 특정 게시판의 즐겨찾기 여부 + 토글. 메인 목록의 별 버튼이 사용한다.

@ProviderFor(FavoriteButton)
final favoriteButtonProvider = FavoriteButtonFamily._();

/// 특정 게시판의 즐겨찾기 여부 + 토글. 메인 목록의 별 버튼이 사용한다.
final class FavoriteButtonProvider
    extends $AsyncNotifierProvider<FavoriteButton, bool> {
  /// 특정 게시판의 즐겨찾기 여부 + 토글. 메인 목록의 별 버튼이 사용한다.
  FavoriteButtonProvider._({
    required FavoriteButtonFamily super.from,
    required (SiteType, String) super.argument,
  }) : super(
         retry: null,
         name: r'favoriteButtonProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$favoriteButtonHash();

  @override
  String toString() {
    return r'favoriteButtonProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  FavoriteButton create() => FavoriteButton();

  @override
  bool operator ==(Object other) {
    return other is FavoriteButtonProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$favoriteButtonHash() => r'd485eea973ac55b90372287b00f68bc3eced306c';

/// 특정 게시판의 즐겨찾기 여부 + 토글. 메인 목록의 별 버튼이 사용한다.

final class FavoriteButtonFamily extends $Family
    with
        $ClassFamilyOverride<
          FavoriteButton,
          AsyncValue<bool>,
          bool,
          FutureOr<bool>,
          (SiteType, String)
        > {
  FavoriteButtonFamily._()
    : super(
        retry: null,
        name: r'favoriteButtonProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 특정 게시판의 즐겨찾기 여부 + 토글. 메인 목록의 별 버튼이 사용한다.

  FavoriteButtonProvider call(SiteType siteType, String board) =>
      FavoriteButtonProvider._(argument: (siteType, board), from: this);

  @override
  String toString() => r'favoriteButtonProvider';
}

/// 특정 게시판의 즐겨찾기 여부 + 토글. 메인 목록의 별 버튼이 사용한다.

abstract class _$FavoriteButton extends $AsyncNotifier<bool> {
  late final _$args = ref.$arg as (SiteType, String);
  SiteType get siteType => _$args.$1;
  String get board => _$args.$2;

  FutureOr<bool> build(SiteType siteType, String board);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}
