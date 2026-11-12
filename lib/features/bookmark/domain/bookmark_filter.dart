import 'package:mocl_flutter/features/database/domain/entities/post_snapshot.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';

/// 스크랩 목록 거르기: 고른 폴더 + 검색어.
abstract final class BookmarkFilter() {
  /// [folderId] 가 null 이면 전체. [query] 는 제목 · 메모 · 사이트 · 게시판 이름에서
  /// 대소문자와 띄어쓰기를 무시하고 찾는다(띄어 쓴 말은 모두 들어 있어야 한다).
  static List<PostSnapshot> apply(
    List<PostSnapshot> items, {
    String? folderId,
    String query = '',
  }) {
    final List<String> words = query
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList(growable: false);
    return items
        .where((b) {
          if (folderId != null && !b.folders.contains(folderId)) return false;
          if (words.isEmpty) return true;
          final String haystack = [
            b.title,
            b.memo,
            b.siteType.title,
            b.boardTitle,
          ].join(' ').toLowerCase();
          return words.every(haystack.contains);
        })
        .toList(growable: false);
  }

  /// 폴더별 글 수.
  static Map<String, int> countByFolder(List<PostSnapshot> items) {
    final Map<String, int> counts = {};
    for (final PostSnapshot b in items) {
      for (final String id in b.folders) {
        counts[id] = (counts[id] ?? 0) + 1;
      }
    }
    return counts;
  }
}
