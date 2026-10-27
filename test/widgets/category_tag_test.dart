import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/core/presentation/widgets/category_tag.dart';

void main() {
  group('CategoryTone.of', () {
    test('말머리 뜻에 따라 색을 고른다', () {
      expect(CategoryTone.of('질문❓'), CategoryTone.blue);
      expect(CategoryTone.of('Q&A'), CategoryTone.blue);
      expect(CategoryTone.of('정보'), CategoryTone.green);
      expect(CategoryTone.of('유머'), CategoryTone.amber);
      expect(CategoryTone.of('사용기'), CategoryTone.violet);
      expect(CategoryTone.of('11번가'), CategoryTone.coral);
    });

    test('모르는 말머리는 slate', () {
      expect(CategoryTone.of('일반'), CategoryTone.slate);
      expect(CategoryTone.of('야구'), CategoryTone.slate);
    });
  });

  group('stripCategoryPrefix', () {
    test('제목 앞 "[말머리]" 만 뗀다', () {
      expect(stripCategoryPrefix('[질문] 제목', '질문'), '제목');
      expect(stripCategoryPrefix('[정보] 제목', '질문'), '[정보] 제목');
      expect(stripCategoryPrefix('제목 [질문]', '질문'), '제목 [질문]');
      expect(stripCategoryPrefix('[질문] 제목', ''), '[질문] 제목');
    });
  });
}
