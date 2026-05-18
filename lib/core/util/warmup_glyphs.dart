import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../config/mocl_text_styles.dart';

class Glyphs {
  const Glyphs._();

  /// 한국어 빈도 상위 음절 (국립국어원 사용 빈도 조사 기반)
  /// 누적 빈도 약 99% 커버. 일반 앱 UI 텍스트는 거의 다 포함됨.
  static const String _frequentKoreanSyllables =
      // ㄱ
      '가각간갈감갑값갔강같개객거건걸검것게겠겨격견결경계고곡곤골곱공과관광괜교구국군굴굽권귀'
      '그극근글금급긋기긴길김깊까깐깔깜깨꺼껏께꼭꽃꾸꿈끄끈끊끓끝'
      // ㄴ
      '나낙난날남납낫낭내냐너넌널넘넣네녀녁년념녕노녹논놀높놓누눈눌느는늘능늦니님'
      // ㄷ
      '다닥단달닭담답당대댁댄더던덜덤덧덩데도독돈돌돕동돼되된두둘둠뒤드든들듣등디딜'
      // ㄹ
      '라락란람랍랑래랜략량러런럴럼럽럿렁렇레려력련렬렴렵령례로록론롤롭롯료루룩룬룰류륙륜률리림립'
      // ㅁ
      '마막만많말맘맛망매맥머먹먼멀멈멋메며면멸명몇모목몰몸못묘무묵문물뭐뭔뭘미민믿밀'
      // ㅂ
      '바박반받발밝밤밥방배백번벌범법베벼벽변별병보복본볼봄봅봉부북분불붓붙뷰비빈빌빔빛빠빨빵뼈'
      // ㅅ
      '사삭산살삼상새색서석선설섬섭성세센셈셔션셨소속손솔솜송쇄쇼수숙순술숨숭숲쉬쉽슈스슨슬슴습승시식신실심십싶'
      // ㅆ ~ ㅇ
      '싸쌀쌍써썼쓰쓴쓸씀씨씩'
      '아악안앉않알암압앗앙앞애액야약얀얄양얘어억언얼없엇엉에엔여역연열염엽영옆예오옥온올옴옵옷와완왔왕왜외왼요용우운울움웃웅워원월위유육윤율으은을음읍응의이익인일임입잇있잎'
      // ㅈ
      '자작잔잘잠잡장재쟁저적전절점접정젖제져졌조족존졸좀좁종좋좌죄주죽준줄중쥐즈즉즐증지직진질짐집짓징짙짚짝짧쪽찌찍찐찔'
      // ㅊ
      '차착찬찰참창찾채책처척천철첫청체쳐쳤초촉촌총최추축춘출춤춥충츠측치친칠침칩칭'
      // ㅋㅌㅍ
      '카칸캐커컨컬컴컵케켜코콜콤콩쾌쿠퀴큐크큰클큼키킬킹'
      '타탁탄탈탐탑탕태택터턴털텀테텍토톤톨톰톱통퇴투툴튀튜트특튼틀티팀'
      '파판팔패팩팬퍼펀펄페편평폐포폭표푸풀품풍퓨프픈플픔피픽필'
      // ㅎ
      '하학한할함합항해핵행향허헌험헤혁현혈혐협형혜호혹혼홀홈홍화확환활황회획효후훈훌훔훨휘휴흐흑흔흘흠흡흥희흰히힘'
      // 앱 UI에서 자주 등장하지만 위에 누락 가능한 글자
      '확인취소저장검색설정알림좋아요댓글공유닫기열기등록추가변경완료종료비밀번호';

  static const String _commonAscii =
      ' 0123456789'
      'abcdefghijklmnopqrstuvwxyz'
      'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
      '.,!?·"\'()[]{}-_/:;@#%&*+=~';

  static Future<void> warmUpGlyphs({
    required List<String> targets,
    required TextStyle textStyle,
  }) async {
    for (var text in targets) {
      final painter = TextPainter(
        text: TextSpan(text: text, style: textStyle),
        textDirection: TextDirection.ltr,
      );

      // 1. 레이아웃 계산 (CPU 단계)
      painter.layout();

      // 2. 가상 캔버스에 그리기 (GPU/Raster 캐시 등록 단계)
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);

      // 여기서 실제로 그려야 Glyph가 캐싱됩니다.
      painter.paint(canvas, Offset.zero);

      // 마무리 (메모리 해제)
      recorder.endRecording().dispose();
    }
  }

  /// 자주 쓰이는 한글/라틴 글리프를 미리 렌더링해 GPU glyph atlas 를 예열한다.
  /// 스크롤 중 새 글자 등장 시 발생하는 `CreateGlyphAtlas` 스파이크를 줄인다.
  ///
  /// 11k+ 음절을 한 번에 layout 하면 height 가 거대해져 메모리/시간 비용이 크므로,
  /// 청크 단위로 잘라서 처리하고 매 청크 사이에 yield 한다.
  static Future<void> warmupKoreanGlyphs(
    AppTextStyles textStyles, {
    bool Function()? shouldAbort, // 중단 여부를 확인할 콜백 추가
  }) async {
    // 현대 한글 음절 전체 (가~힣), 중복 제거 됨
    final uniqueChars = <int>{
      ..._frequentKoreanSyllables.runes,
      ..._commonAscii.runes,
    };
    final text = String.fromCharCodes(uniqueChars);

    final styles = <TextStyle>[
      // 실제 앱에서 사용하는 스타일과 동일하게
      textStyles.titleTextStyle,
      textStyles.smallTextStyle,
    ];

    const int chunkSize = 80; // 청크당 문자 수 (작을수록 한 번에 점유하는 UI 시간 짧음)
    const double maxWidth = 1024; // layout 최대 너비

    for (final style in styles) {
      for (int start = 0; start < text.length; start += chunkSize) {
        // 1. 루프 시작 시점에 체크
        if (shouldAbort != null && shouldAbort()) return;

        final end = (start + chunkSize) > text.length
            ? text.length
            : (start + chunkSize);
        final chunk = text.substring(start, end);

        final tp = TextPainter(
          text: TextSpan(text: chunk, style: style),
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: maxWidth);

        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);
        tp.paint(canvas, Offset.zero);
        final picture = recorder.endRecording();

        // 실제 텍스트 영역에 맞춰 rasterize 해야 glyph 가 atlas 에 업로드됨.
        // 1x1 로 하면 Impeller 가 화면 밖 draw 를 컬링해 워밍업 효과가 사라진다.
        final int w = tp.width.ceil().clamp(8, 2048);
        final int h = tp.height.ceil().clamp(8, 2048);
        final image = await picture.toImage(w, h);
        image.dispose();
        picture.dispose();
        tp.dispose();

        // 다음 프레임까지 양보 → 사용자 인터랙션/애니메이션이 우선 처리됨.
        await SchedulerBinding.instance.endOfFrame;
      }
    }
  }
}
