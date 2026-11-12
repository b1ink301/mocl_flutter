/// 스크랩 폴더. 글은 [PostSnapshot.folders] 에 이 [id] 를 담아 폴더에 들어간다
/// (한 글이 여러 폴더에 들 수 있는 태그 방식).
///
/// sembast `bookmark_folders` 스토어에 `id → toJson()` 으로 저장한다. 순서는 만든 순서.
class const BookmarkFolder({
  required final String id,
  required final String name,

  /// 색(말머리 태그 색 `CategoryTone` 의 순번). 모르는 값은 화면에서 첫 색으로 본다.
  required final int tone,
  required final int createdAt,
}) {
  /// 폴더 이름 최대 길이.
  static const int maxNameLength = 20;

  /// 폴더 개수 한도(칩 줄이 끝없이 길어지지 않게).
  static const int maxFolders = 20;

  factory fromJson(String id, Map<String, Object?> json) => BookmarkFolder(
    id: id,
    name: json['name'] as String? ?? '',
    tone: (json['tone'] as num?)?.toInt() ?? 0,
    createdAt: (json['createdAt'] as num?)?.toInt() ?? 0,
  );

  Map<String, Object?> toJson() => {
    'name': name,
    'tone': tone,
    'createdAt': createdAt,
  };

  BookmarkFolder copyWith({String? name, int? tone}) => BookmarkFolder(
    id: id,
    name: name ?? this.name,
    tone: tone ?? this.tone,
    createdAt: createdAt,
  );

  @override
  bool operator ==(Object other) =>
      other is BookmarkFolder &&
      other.id == id &&
      other.name == name &&
      other.tone == tone &&
      other.createdAt == createdAt;

  @override
  int get hashCode => Object.hash(id, name, tone, createdAt);
}
