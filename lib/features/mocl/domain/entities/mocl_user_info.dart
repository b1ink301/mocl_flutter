class UserInfo {
  final String id;
  final String nickName;
  final String nickImage;
  final String nameMemo;
  final String ip;
  final bool isBlock;
  final bool isMe;
  final bool isAuthor;

  UserInfo({
    required this.id,
    required this.nickName,
    required this.nickImage,
  })  : nameMemo = '',
        ip = '',
        isBlock = false,
        isMe = false,
        isAuthor = false;
}
