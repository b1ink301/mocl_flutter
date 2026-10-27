import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';

part 'mocl_main_item.freezed.dart';
part 'mocl_main_item.g.dart';

@freezed
abstract class MainItem with _$MainItem {
  const factory({
    required SiteType siteType,
    required String board,
    required String text,
    required String url,
    required int orderBy,
    @Default(0) int type,
    // 하위 메뉴를 가진 컨테이너인지(네이버카페의 카페, 정적 목록의 children 보유
    // 항목). UI 는 사이트를 따지지 않고 이 값만 보고 '담기' 대신 '진입'으로 그린다.
    @Default(false) bool hasItem,
    @Default('') String icon,
    // 게시판 추가 다이얼로그에서 카테고리 그룹핑에 쓰는 표시 전용 값.
    // DB 에는 저장하지 않는다(매퍼가 매핑하지 않으면 기본값 '').
    @Default('') String category,
    // 하위 메뉴 항목일 때 부모의 board/표시명. 부모가 없으면 빈 문자열.
    // parentText 는 홈에서 '자유게시판 · <카페명>' 처럼 출처를 밝히는 데 쓰므로
    // (category 와 달리) DB 에도 저장한다.
    @Default('') String parentBoard,
    @Default('') String parentText,
  }) = _MainItem;

  factory fromJson(Map<String, dynamic> json) => _$MainItemFromJson(json);

  factory empty() => MainItem(
    siteType: SiteType.damoang,
    board: '',
    text: '',
    url: '',
    orderBy: 1,
  );
}
