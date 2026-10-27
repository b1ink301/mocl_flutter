/// 앱 안 동영상 플레이어로 재생할 수 있는 링크.
sealed class const VideoLink() {
  /// 플레이어에서 "브라우저로 열기" 를 누르면 여는 원래 주소.
  String get sourceUrl;
}

/// 유튜브 영상. IFrame 플레이어로 재생한다.
///
/// [startSeconds] 는 `t=` / `start=` 로 지정한 시작 위치(초).
final class const YouTubeLink(
  final String videoId, {
  final int startSeconds = 0,
}) extends VideoLink {
  @override
  String get sourceUrl =>
      'https://www.youtube.com/watch?v=$videoId'
      '${startSeconds > 0 ? '&t=${startSeconds}s' : ''}';
}

/// mp4 · webm · m3u8 처럼 주소가 곧 영상 파일인 링크. video_player 로 재생한다.
final class const DirectVideoLink(final String url) extends VideoLink {
  @override
  String get sourceUrl => url;
}

/// 본문 링크가 동영상이면 [VideoLink] 로 바꾼다. 아니면 null.
abstract final class VideoLinkResolver() {
  static final RegExp _idRe = RegExp(r'^[a-zA-Z0-9_-]{11}$');

  static const Set<String> _videoExtensions = {
    '.mp4',
    '.m4v',
    '.mov',
    '.webm',
    '.mkv',
    '.m3u8',
  };

  static VideoLink? resolve(String url) {
    final Uri? uri = Uri.tryParse(url.startsWith('//') ? 'https:$url' : url);
    if (uri == null || !uri.scheme.startsWith('http')) return null;

    final YouTubeLink? youtube = _youtube(uri);
    if (youtube != null) return youtube;

    final String path = uri.path.toLowerCase();
    if (_videoExtensions.any(path.endsWith)) {
      return DirectVideoLink(uri.toString());
    }
    return null;
  }

  /// youtube.com/watch?v= · youtu.be/ · /embed/ · /shorts/ · /live/ · /v/
  static YouTubeLink? _youtube(Uri uri) {
    final String host = uri.host.toLowerCase();
    final List<String> segs = uri.pathSegments
        .where((e) => e.isNotEmpty)
        .toList(growable: false);

    String? id;
    if (host == 'youtu.be') {
      id = segs.firstOrNull;
    } else if (host == 'youtube.com' ||
        host.endsWith('.youtube.com') ||
        host == 'youtube-nocookie.com' ||
        host.endsWith('.youtube-nocookie.com')) {
      if (segs.firstOrNull == 'watch') {
        id = uri.queryParameters['v'];
      } else if (segs.length >= 2 &&
          const {'embed', 'shorts', 'live', 'v'}.contains(segs[0])) {
        id = segs[1];
      }
    }
    if (id == null || !_idRe.hasMatch(id)) return null;

    final String? t = uri.queryParameters['t'] ?? uri.queryParameters['start'];
    return YouTubeLink(id, startSeconds: _seconds(t));
  }

  /// `90`, `90s`, `1m30s`, `1h2m3s` → 초.
  static int _seconds(String? t) {
    if (t == null || t.isEmpty) return 0;
    final int? plain = int.tryParse(t);
    if (plain != null) return plain;
    final Match? m = RegExp(r'^(?:(\d+)h)?(?:(\d+)m)?(?:(\d+)s)?$')
        .firstMatch(t);
    if (m == null) return 0;
    int part(int i) => int.tryParse(m.group(i) ?? '') ?? 0;
    return part(1) * 3600 + part(2) * 60 + part(3);
  }
}
