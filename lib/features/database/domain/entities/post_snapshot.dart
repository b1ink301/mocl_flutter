import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mocl_shared/entities/mocl_details.dart';
import 'package:mocl_shared/entities/mocl_list_item.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_shared/entities/mocl_user_info.dart';

part 'post_snapshot.freezed.dart';
part 'post_snapshot.g.dart';

/// 나중에 다시 열 수 있게 남겨 둔 게시물 한 개(스크랩 · 최근 본 글이 같이 쓴다).
///
/// sembast 의 `bookmarks` · `history` 스토어에 JSON 으로 저장된다. ListItem 은
/// 직렬화를 지원하지 않으므로, 목록 화면에서 다시 상세로 진입할 수 있도록 필요한
/// 필드를 명시적으로 보관하고 [toListItem] 으로 복원한다.
///
/// [savedAt] 은 그 스토어에 넣은 시각(ms) — 스크랩은 스크랩한 때, 최근 본 글은 마지막으로 본 때.
/// 필드 이름을 바꾸면 저장된 JSON 과 어긋나니 바꾸지 말 것. 나중에 더한 필드([folders] ·
/// [memo])는 기본값이 있어 옛 JSON 도 그대로 읽힌다.
@freezed
abstract class const PostSnapshot._() with _$PostSnapshot {
  const factory({
    required SiteType siteType,
    required int id,
    required String title,
    required String url,
    required String board,
    required String boardTitle,
    required String info,
    required String time,
    required String reply,
    required String userId,
    required String nickName,
    required String nickImage,
    required int savedAt,

    /// 스크랩 폴더 id(`BookmarkFolder.id`). 한 글을 여러 폴더에 넣을 수 있다. 스크랩에서만 쓴다.
    @Default(<String>[]) List<String> folders,

    /// 스크랩에 붙인 한 줄 메모. 스크랩에서만 쓴다.
    @Default('') String memo,
  }) = _PostSnapshot;

  factory fromJson(Map<String, dynamic> json) => _$PostSnapshotFromJson(json);

  factory fromListItem(SiteType siteType, ListItem item, int savedAt) =>
      PostSnapshot(
        siteType: siteType,
        id: item.id,
        title: item.title,
        url: item.url,
        board: item.board,
        boardTitle: item.boardTitle,
        info: item.info,
        time: item.time,
        reply: item.reply,
        userId: item.userInfo.id,
        nickName: item.userInfo.nickName,
        nickImage: item.userInfo.nickImage,
        savedAt: savedAt,
      );

  /// 상세를 받은 뒤 남길 때. 링크 · 알림으로 연 글은 목록 항목에 제목 · 작성자가
  /// 비어 있을 수 있어 상세 값으로 채운다(목록 값이 있으면 그대로 둔다 — 번역 제목이
  /// 아니라 원문을 남기기 위해서도 상세의 원본 [details] 를 넘길 것).
  factory fromDetails(
    SiteType siteType,
    ListItem item,
    Details details,
    int savedAt,
  ) {
    final bool hasUser = item.userInfo.nickName.isNotEmpty;
    return PostSnapshot.fromListItem(
      siteType,
      item.copyWith(
        title: item.title.isNotEmpty ? item.title : details.title,
        time: item.time.isNotEmpty ? item.time : details.time,
        userInfo: hasUser ? item.userInfo : details.userInfo,
      ),
      savedAt,
    );
  }

  /// 스토어 · 화면에서 쓰는 키(`clien:42`).
  String get key => keyOf(siteType, id);

  static String keyOf(SiteType siteType, int id) => '${siteType.name}:$id';

  ListItem toListItem() => ListItem.empty().copyWith(
    id: id,
    title: title,
    url: url,
    board: board,
    boardTitle: boardTitle,
    info: info,
    time: time,
    reply: reply,
    userInfo: UserInfo(id: userId, nickName: nickName, nickImage: nickImage),
    isRead: true,
  );
}
