import 'package:mocl_flutter/core/domain/entities/mocl_comment_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/features/translation/domain/html_text_translator.dart';
import 'package:mocl_flutter/features/translation/domain/translator.dart';

/// 상세 글을 번역한다. 제목 · 본문을 먼저 내보내고, 댓글은 [commentBatch] 개씩
/// 번역할 때마다 지금까지의 결과를 내보낸다(댓글이 수백 개여도 먼저 읽을 수 있게).
class const DetailsTranslator(
  final Translator translator, {
  final int commentBatch = 20,
}) {
  Stream<Details> translate(Details original) async* {
    Future<List<String>> run(List<String> texts) => translator.translate(texts);

    final String title = HtmlTextTranslator.needsTranslation(original.title)
        ? (await run([original.title])).first
        : original.title;
    final String body = (await HtmlTextTranslator.translateAll([
      original.bodyHtml,
    ], run)).first;
    Details current = original.copyWith(title: title, bodyHtml: body);
    yield current;

    final List<CommentItem> comments = [...original.comments];
    for (var start = 0; start < comments.length; start += commentBatch) {
      final int end = (start + commentBatch).clamp(0, comments.length);
      final List<String> bodies = await HtmlTextTranslator.translateAll([
        for (var i = start; i < end; i++) comments[i].bodyHtml,
      ], run);
      for (var i = start; i < end; i++) {
        comments[i] = comments[i].copyWith(bodyHtml: bodies[i - start]);
      }
      current = current.copyWith(comments: List.unmodifiable(comments));
      yield current;
    }
  }
}
