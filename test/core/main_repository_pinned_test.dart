import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/database/data/models/main_item_model.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/reddit/reddit_parser.dart';
import 'package:mocl_flutter/features/main_page/data/datasources/main_data_source.dart';
import 'package:mocl_flutter/features/main_page/data/repositories/mocl_main_repository_impl.dart';

class _FakeDataSource({
  final List<MainItem> live = const [],
  final Failure? liveFailure,
}) implements MainDataSource {
  var remoteCalls = 0;

  @override
  List<MainItem> get pinnedBoards => const RedditParser().pinnedBoards;

  @override
  Future<List<MainItemModel>> getAllFromRemote(SiteType siteType) async {
    remoteCalls++;
    return const [];
  }

  @override
  Future<List<MainItemModel>> getAllFromJson(SiteType siteType) async =>
      const [];

  @override
  Future<List<MainItem>> getAllLive(SiteType siteType) async {
    if (liveFailure case final Failure f) throw f;
    return live;
  }

  @override
  Future<List<MainItem>> getSubMenuLive(MainItem parent) async => const [];

  @override
  Future<List<MainItem>> getSubMenuFromJson(MainItem parent) async => const [];
}

void main() {
  test('레딧은 board_link.json 대신 구독 목록을 쓰고 홈을 맨 앞에 붙인다', () async {
    final dataSource = _FakeDataSource(
      live: const [
        MainItem(
          siteType: SiteType.reddit,
          board: 'r/FlutterDev',
          text: 'r/FlutterDev',
          url: 'https://www.reddit.com/r/FlutterDev',
          orderBy: 0,
        ),
      ],
    );
    final repo = MainRepositoryImpl(dataSource: dataSource);

    final items = (await repo.getMainListFromJson(siteType: SiteType.reddit))
        .getOrElse((f) => fail('$f'));

    expect(dataSource.remoteCalls, 0);
    expect(items.map((e) => e.board), [RedditParser.homeTitle, 'r/FlutterDev']);
    expect(items.first.url, 'https://www.reddit.com');
  });

  test('로그인하지 않았으면 NotLoginFailure 를 그대로 올린다', () async {
    final repo = MainRepositoryImpl(
      dataSource: _FakeDataSource(
        liveFailure: const NotLoginFailure(message: 'login'),
      ),
    );

    final result = await repo.getMainListFromJson(siteType: SiteType.reddit);

    expect(result.getLeft().toNullable(), isA<NotLoginFailure>());
  });
}
