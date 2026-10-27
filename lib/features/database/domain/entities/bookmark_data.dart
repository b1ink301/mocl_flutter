import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_user_info.dart';

part 'bookmark_data.freezed.dart';
part 'bookmark_data.g.dart';

/// 스크랩(북마크)된 게시물. sembast 의 `bookmarks` 스토어에 JSON 으로 저장된다.
/// ListItem 은 직렬화를 지원하지 않으므로, 목록 화면에서 다시 상세로 진입할 수
/// 있도록 필요한 필드를 명시적으로 보관하고 [toListItem] 으로 복원한다.
@freezed
abstract class const BookmarkData._() with _$BookmarkData {
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
  }) = _BookmarkData;

  factory fromJson(Map<String, dynamic> json) => _$BookmarkDataFromJson(json);

  factory fromListItem(SiteType siteType, ListItem item, int savedAt) =>
      BookmarkData(
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
