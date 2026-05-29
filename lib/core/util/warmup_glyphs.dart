import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class Glyphs {
  const Glyphs._();

  /// 한국어 빈도 상위 음절 (국립국어원 사용 빈도 조사 기반)
  /// 누적 빈도 약 99% 커버. 일반 앱 UI 텍스트는 거의 다 포함됨.
  static const String _frequentKoreanSyllables =
      // ㄱ
      '가각간갇갈감갑값강갖같개객갤갱거걱건걷걸검겁것게겠겨격견결겸경계고곡곤골곳공과관광괜교구국군굴궁권귀규그극근글금급기긴길김깊까깍깐깔깜깝깨꺼껏께꼬꼴꼭꽃꽉꾸꿀꿈끄끈끊끌끓끔끝끼'
      // ㄴ
      '나낙난날남납낫낭내냉너넉넌널넓넘넣네넥넷녀년념녕노녹논놀놈농높놓누눈뉴느는늘능늦니님닉' // '넷, 닉' 추가
      // ㄷ
      '다닥단닫달닭담답당대댁더덕던덜덤덥덩데도독돈돌돕동돼되된두둑둘둠뒤드득든듣들듬듯등디딜딩' // '딩' 추가
      // ㄹ
      '라락란람랍랑래략량러럭런럴럼럽럿렁렇레려력련렬렴렵령례로록론롤롬롭롯료룡루룩룬룰류륙륜률르른를름릉리린림립릭랜랭램랩' // '릭, 랜, 랭, 램, 랩' 추가
      // ㅁ
      '마막만많말맘맛망맞매맥맨머먹먼멀멈멋멍메며면멸명몇모목몰몸못묘무묵문물뭐뭔뭘미민믿밀밑'
      // ㅂ
      '바박밖반받발밝밤밥방배백버번벌범법벗베벼벽변별병보복본볼봄봅봉부북분불붓붙뷰비빈빌빔빛빠빨빵빼뺨뼈뽑뿌뿐쁘봇' // '봇' 추가
      // ㅅ
      '사삭산살삼상새색생서석선설섬섭성세센셈셔션셨소속손솔솜송솥쇄쇼수숙순술숨숭숲쉬쉽슈스슨슬슴습승시식신실심십싶싸싹싼쌀쌍써썼쓰쓴쓸씀씨씩샵' // '샵' 추가
      // ㅇ
      '아악안앉않알암압앗앙앞애액야약양얘어억언얻얼엄업없엇엉에엔여역연열염엽영옆예오옥온올옴옵옷와완왔왕왜외왼요용우운울움웃웅워원월위유육윤율으은을음읍응의이익인일임입잇있잊잎'
      // ㅈ
      '자작잔잠잡장재쟁저적전절점접정젖제져졌조족존졸좀좁종좋좌죄주죽준줄중쥐즈즉즐증지직진질짐집짓징짙짚짜짝짧쪽찌찍찐찔'
      // ㅊ
      '차착찬찰참창찾채책처척천철첫청체쳐쳤초촉촌총최추축춘출춤춥충춰취츠측치친칠침칩칭챗' // '챗' 추가
      // ㅋㅌㅍㅎ + 현대 UI 외래어 대응
      '카칸캐커컨컬컴컵케켜코콜콤콩쾌쿠퀴큐크큰클큼키킬킹콘' // '콘' 추가
      '타탁탄탈탐탑탕태택터턴털텀테텍토톤톨톰톱통퇴투툴튀튜트특튼틀티팀톡팅텐' // '톡, 팅, 텐' 추가
      '파판팔패팩팬퍼펀펄페편평폐포폭표푸풀품풍퓨프픈플픔피픽필폰핑' // '폰, 핑' 추가
      '하학한할함합항해핵행향허헌험헤혁현혈혐협형혜호혹혼홀홈홍화확환활황회획효후훈훌훔훨휘휴흐흑흔흘흠흡흥희흰히힘'
      '확인취소저장검색설정알림좋아요댓글공유닫기열기등록추가변경완료종료비밀번호뒤로로그인나가기웹앱탭폼';

  static const String _commonAscii =
      ' 0123456789'
      'abcdefghijklmnopqrstuvwxyz'
      'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
      '.,!?·"\'()[]{}-_/:;@#%&*+=~';

  static final String _warmupText = () {
    final uniqueChars = <int>{
      ..._frequentKoreanSyllables.runes,
      ..._commonAscii.runes,
    };
    return String.fromCharCodes(uniqueChars);
  }();

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
    List<TextStyle> styles, {
    bool Function()? shouldAbort, // 중단 여부를 확인할 콜백 추가
  }) async {
    const int chunkSize = 80; // 청크당 문자 수 (작을수록 한 번에 점유하는 UI 시간 짧음)
    const double maxWidth = 1024; // layout 최대 너비

    for (final style in styles) {
      for (int start = 0; start < _warmupText.length; start += chunkSize) {
        // 1. 루프 시작 시점에 체크
        if (shouldAbort != null && shouldAbort()) return;

        final end = (start + chunkSize) > _warmupText.length
            ? _warmupText.length
            : (start + chunkSize);
        final chunk = _warmupText.substring(start, end);

        // idle 우선순위로 예약 → 사용자 인터랙션/스크롤/애니메이션 중에는 대기.
        // 한 청크의 layout/paint 가 끝나야 다음이 시작되며, 그 사이 프레임 워크가
        // 더 중요한 작업을 처리할 수 있다.
        SchedulerBinding.instance.scheduleTask<void>(() async {
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
        }, Priority.idle);
      }
    }
  }
}
