import 'package:mocl_flutter/core/domain/entities/mocl_comment_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';

/// 댓글 하나를 쓰는 요청.
///
/// [details] 는 지금 보고 있는 상세(로그인 여부 · CSRF · 사이트별 값)이고,
/// [parent] 가 있으면 그 댓글에 다는 대댓글이다.
class const CommentWrite({
  required final ListItem item,
  required final Details details,
  required final String content,
  final CommentItem? parent,
});
