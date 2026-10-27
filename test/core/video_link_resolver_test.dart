import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/features/detail_page/domain/video_link_resolver.dart';

void main() {
  group('유튜브', () {
    void expectYouTube(String url, String id, {int start = 0}) {
      final VideoLink? link = VideoLinkResolver.resolve(url);
      expect(link, isA<YouTubeLink>(), reason: url);
      final YouTubeLink yt = link! as YouTubeLink;
      expect(yt.videoId, id, reason: url);
      expect(yt.startSeconds, start, reason: url);
    }

    test('주소 형식마다 영상 id 를 뽑는다', () {
      expectYouTube(
        'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
        'dQw4w9WgXcQ',
      );
      expectYouTube(
        'https://m.youtube.com/watch?v=dQw4w9WgXcQ&feature=share',
        'dQw4w9WgXcQ',
      );
      expectYouTube('https://youtu.be/dQw4w9WgXcQ?si=abc', 'dQw4w9WgXcQ');
      expectYouTube('https://www.youtube.com/embed/dQw4w9WgXcQ', 'dQw4w9WgXcQ');
      expectYouTube(
        'https://www.youtube-nocookie.com/embed/dQw4w9WgXcQ',
        'dQw4w9WgXcQ',
      );
      expectYouTube('https://youtube.com/shorts/dQw4w9WgXcQ', 'dQw4w9WgXcQ');
      expectYouTube('https://www.youtube.com/live/dQw4w9WgXcQ', 'dQw4w9WgXcQ');
      expectYouTube('//www.youtube.com/embed/dQw4w9WgXcQ', 'dQw4w9WgXcQ');
    });

    test('시작 위치를 초로 읽는다', () {
      expectYouTube(
        'https://youtu.be/dQw4w9WgXcQ?t=90',
        'dQw4w9WgXcQ',
        start: 90,
      );
      expectYouTube(
        'https://www.youtube.com/watch?v=dQw4w9WgXcQ&t=1m30s',
        'dQw4w9WgXcQ',
        start: 90,
      );
      expectYouTube(
        'https://www.youtube.com/embed/dQw4w9WgXcQ?start=42',
        'dQw4w9WgXcQ',
        start: 42,
      );
      expect(
        const YouTubeLink('dQw4w9WgXcQ', startSeconds: 90).sourceUrl,
        'https://www.youtube.com/watch?v=dQw4w9WgXcQ&t=90s',
      );
    });

    test('영상이 아닌 유튜브 주소는 건너뛴다', () {
      for (final url in [
        'https://www.youtube.com/',
        'https://www.youtube.com/@channel',
        'https://www.youtube.com/playlist?list=PL123',
        'https://www.youtube.com/watch?v=short',
      ]) {
        expect(VideoLinkResolver.resolve(url), isNull, reason: url);
      }
    });
  });

  group('영상 파일', () {
    test('확장자로 판단한다(쿼리는 무시)', () {
      for (final url in [
        'https://cdn.example.com/a/b.mp4',
        'https://cdn.example.com/a/b.MP4?token=1',
        'https://cdn.example.com/live/index.m3u8',
        'https://cdn.example.com/c.webm',
      ]) {
        final VideoLink? link = VideoLinkResolver.resolve(url);
        expect(link, isA<DirectVideoLink>(), reason: url);
        expect(link!.sourceUrl, url, reason: url);
      }
    });

    test('이미지 · 일반 페이지는 null', () {
      for (final url in [
        'https://cdn.example.com/a.gif',
        'https://www.clien.net/service/board/park/1',
        'https://example.com/mp4',
        'mailto:a@b.com',
      ]) {
        expect(VideoLinkResolver.resolve(url), isNull, reason: url);
      }
    });
  });
}
