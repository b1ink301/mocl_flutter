part of 'reddit_parser.dart';

extension StringExt on String {
  DateTime _toDateTime() {
    throw UnimplementedError('_toDateTime');
  }
}

extension ElementDetialExt on Element {
  CommentItem? _toComments(int index) {
    throw UnimplementedError('_toComments');
  }

  Details _toDetails(List<CommentItem> comments) {
    throw UnimplementedError('_toDetails');
  }
}

extension ElementListExt on Element {
  ListItem? _toListItem(
      int lastId, String baseUrl, String boardTitle, bool isShowNickImage) {
    throw UnimplementedError('_toDateTime');
  }
}

extension ElementMainExt on Element {
  MainItem? _toMainItem(String baseUrl, int orderBy) {
    throw UnimplementedError('_toMainItem');
  }
}
