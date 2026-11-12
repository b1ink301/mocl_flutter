/// 앱 아이콘을 길게 누르면 나오는 바로가기(Android 앱 단축키 · iOS 퀵 액션).
///
/// [type] 은 OS 에 등록되는 값이라 바꾸면 사용자가 홈 화면에 꺼내 둔 바로가기가
/// 동작하지 않는다(이름을 바꾸지 말 것). [icon] 은 Android drawable 이름
/// (`res/drawable/ic_shortcut_*.xml`, 리소스 축소에서 `res/raw/keep_shortcuts.xml` 이 지킨다).
enum AppShortcut({
  required final String type,
  required final String title,
  required final String icon,
}) {
  issues(type: 'issues', title: '지금 이슈', icon: 'ic_shortcut_issues'),
  bookmarks(type: 'bookmarks', title: '스크랩', icon: 'ic_shortcut_bookmarks'),
  history(type: 'history', title: '최근 본 글', icon: 'ic_shortcut_history');

  static AppShortcut? fromType(String type) {
    for (final AppShortcut s in values) {
      if (s.type == type) return s;
    }
    return null;
  }

  /// 이 빌드에서 보일 바로가기. 서버가 없는 빌드는 이슈를 뺀다.
  static List<AppShortcut> visible({required bool issues}) => <AppShortcut>[
    if (issues) AppShortcut.issues,
    bookmarks,
    history,
  ];
}
