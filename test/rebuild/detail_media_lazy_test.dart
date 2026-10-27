import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_details.dart';

import '../helpers/screen_harness.dart';

/// 미디어가 많은 본문(clien news 19261182 형태)의 렌더 회귀 테스트.
///
/// 배경: fwfh_chewie 의 `VideoPlayer` 는 `initState` 에서 곧바로
/// `VideoPlayerController.network()` + `initialize()` 를 호출한다. 본문을
/// 통짜 위젯으로 렌더하면 화면 밖 video 까지 전부 mount 돼 ExoPlayer 가
/// 동시에 생성되고 힙이 터진다(실제 OOM 발생 케이스).
void main() {
  /// autoplay/loop 가 걸린 video 5개 + 이미지 24개짜리 본문.
  String mediaBody() {
    final b = StringBuffer('<p>본문 시작</p>');
    for (int i = 0; i < 24; i++) {
      b.write('<p><img src="https://example.com/img$i.jpg"></p>');
      if (i % 5 == 4) {
        b.write(
          '<video autoplay="" controls="" loop="loop" muted preload="auto">'
          '<source src="https://example.com/v$i.mp4" type="video/mp4">'
          '</video>',
        );
      }
    }
    return b.toString();
  }

  Details detailsWithMedia() {
    final base = fakeDetails();
    return Details(
      title: base.title,
      time: base.time,
      viewCount: base.viewCount,
      likeCount: base.likeCount,
      bodyHtml: mediaBody(),
      info: base.info,
      userInfo: base.userInfo,
      comments: base.comments,
    );
  }

  testWidgets('미디어가 많은 본문을 렌더해도 예외가 없다 (본문 sliver 렌더 회귀)', (tester) async {
    await pumpDetailScreen(tester, details: detailsWithMedia());

    // 본문을 RenderMode.sliverList 로 바꾸면서 box 위젯(RepaintBoundary /
    // SelectionArea)으로 감싸면 여기서 렌더 예외가 난다.
    expect(tester.takeException(), isNull);
  });

  testWidgets('탭하기 전에는 video 플레이어가 mount 되지 않는다', (tester) async {
    await pumpDetailScreen(tester, details: detailsWithMedia());

    // fwfh_chewie 의 VideoPlayer 가 mount 됐다면 initState 에서 video_player
    // 플러그인을 호출해 MissingPluginException 이 떴을 것이다.
    expect(tester.takeException(), isNull);

    bool hasType(String name) =>
        tester.allWidgets.any((w) => w.runtimeType.toString() == name);

    expect(
      hasType('VideoPlayer'),
      isFalse,
      reason: '탭 전에 fwfh_chewie VideoPlayer 가 mount 되면 ExoPlayer 가 즉시 생성된다',
    );
    expect(
      hasType('_LazyVideoPlayer'),
      isTrue,
      reason: 'video 는 탭 전까지 지연 플레이스홀더로 렌더돼야 한다',
    );
  });

  testWidgets('본문 이미지는 화면에 보이는 만큼만 mount 된다', (tester) async {
    final b = StringBuffer();
    for (int i = 0; i < 24; i++) {
      b.write(
        '<p><img src="https://example.com/img$i.jpg" '
        'width="400" height="400"></p>',
      );
    }
    final base = fakeDetails();
    await pumpDetailScreen(
      tester,
      details: Details(
        title: base.title,
        time: base.time,
        viewCount: base.viewCount,
        likeCount: base.likeCount,
        bodyHtml: b.toString(),
        info: base.info,
        userInfo: base.userInfo,
        comments: base.comments,
      ),
    );

    // RenderMode.sliverList 로 렌더돼야 화면 밖 이미지가 mount 되지 않는다.
    expect(
      tester.allWidgets.any((w) => w.runtimeType.toString() == 'SliverList'),
      isTrue,
      reason: '본문이 sliverList 로 렌더되지 않으면 24장이 전부 mount 된다',
    );

    final int mounted = tester.allWidgets
        .where((w) => w.runtimeType.toString() == '_RetryableCachedImage')
        .length;
    expect(
      mounted,
      lessThan(24),
      reason:
          '화면 밖 이미지까지 mount 되면 디코딩된 비트맵이 전부 상주한다 '
          '(실측: 24장 중 3장)',
    );
  });
}
