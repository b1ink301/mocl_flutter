use once_cell::sync::Lazy;
use regex::Regex;
use scraper::{ElementRef, Html, Selector};

/// 긱뉴스 리스트 1개 row 를 표현하는 DTO.
/// Dart 측에서는 `RustListItem` 으로 그대로 매핑됨.
#[derive(Debug, Clone)]
pub struct RustListItem {
    pub id: i64,
    pub title: String,
    pub reply: String,
    pub category: String,
    pub time: String,
    pub url: String,
    pub info: String,
    pub like: String,
    pub author: String,
}

// ---- Selectors / Regex (한 번만 컴파일) -----------------------------------

static SEL_TOPIC_ROW: Lazy<Selector> =
    Lazy::new(|| Selector::parse("div.topic_row").unwrap());
static SEL_DESC_LINK: Lazy<Selector> =
    Lazy::new(|| Selector::parse("div.topicdesc > a").unwrap());
// h2.topic-title-heading -> h2 -> h1 폴백 (Dart 측과 동일)
static SEL_TITLE_H2_CLASS: Lazy<Selector> =
    Lazy::new(|| Selector::parse("div.topictitle a h2.topic-title-heading").unwrap());
static SEL_TITLE_H2: Lazy<Selector> =
    Lazy::new(|| Selector::parse("div.topictitle a h2").unwrap());
static SEL_TITLE_H1: Lazy<Selector> =
    Lazy::new(|| Selector::parse("div.topictitle a h1").unwrap());
static SEL_TOPIC_URL: Lazy<Selector> =
    Lazy::new(|| Selector::parse("span.topicurl").unwrap());
static SEL_POINTS: Lazy<Selector> =
    Lazy::new(|| Selector::parse(r#"div.topicinfo span[id^="tp"]"#).unwrap());
static SEL_AUTHOR: Lazy<Selector> =
    Lazy::new(|| Selector::parse(r#"div.topicinfo a[href^="/@"]"#).unwrap());
static SEL_TIME_SPAN: Lazy<Selector> =
    Lazy::new(|| Selector::parse("div.topicinfo span[title]").unwrap());
static SEL_TOPIC_INFO: Lazy<Selector> =
    Lazy::new(|| Selector::parse("div.topicinfo").unwrap());
static SEL_COMMENT_GO: Lazy<Selector> =
    Lazy::new(|| Selector::parse(r#"div.topicinfo a[href*="go=comments"]"#).unwrap());
static SEL_COMMENT_FB: Lazy<Selector> =
    Lazy::new(|| Selector::parse(r#"div.topicinfo a[href^="topic?id="]"#).unwrap());

static RE_TOPIC_ID: Lazy<Regex> =
    Lazy::new(|| Regex::new(r"topic\?id=(\d+)").unwrap());
static RE_TIME: Lazy<Regex> =
    Lazy::new(|| Regex::new(r"(\d+(?:일|시간|분|초)전|방금)").unwrap());
static RE_DIGITS: Lazy<Regex> = Lazy::new(|| Regex::new(r"(\d+)").unwrap());

// ---- Helpers --------------------------------------------------------------

fn text_trim(el: ElementRef<'_>) -> String {
    el.text().collect::<String>().trim().to_string()
}

fn first_text(row: ElementRef<'_>, sel: &Selector) -> String {
    row.select(sel).next().map(text_trim).unwrap_or_default()
}

// ---- Public API -----------------------------------------------------------

/// 긱뉴스 리스트 페이지(HTML 문자열)을 파싱해서 row 배열 반환.
/// `base_url` 은 `https://news.hada.io` 처럼 스킴+호스트.
pub fn parse_geek_news_list(html: String, base_url: String) -> Vec<RustListItem> {
    let doc = Html::parse_document(&html);
    let mut out: Vec<RustListItem> = Vec::with_capacity(32);

    for row in doc.select(&SEL_TOPIC_ROW) {
        // topic id
        let id: i64 = row
            .select(&SEL_DESC_LINK)
            .next()
            .and_then(|a| a.value().attr("href"))
            .and_then(|href| RE_TOPIC_ID.captures(href))
            .and_then(|caps| caps.get(1))
            .and_then(|m| m.as_str().parse().ok())
            .unwrap_or(-1);
        if id <= 0 {
            continue;
        }

        // title (h2.topic-title-heading -> h2 -> h1)
        let title = row
            .select(&SEL_TITLE_H2_CLASS)
            .next()
            .or_else(|| row.select(&SEL_TITLE_H2).next())
            .or_else(|| row.select(&SEL_TITLE_H1).next())
            .map(text_trim)
            .unwrap_or_default();
        if title.is_empty() {
            continue;
        }

        let category = first_text(row, &SEL_TOPIC_URL);
        let points = row
            .select(&SEL_POINTS)
            .next()
            .map(text_trim)
            .unwrap_or_else(|| "0".to_string());
        let author = first_text(row, &SEL_AUTHOR);

        // time: span[title] 우선, 아니면 topicinfo 텍스트 정규식
        let time = if let Some(ts) = row.select(&SEL_TIME_SPAN).next() {
            text_trim(ts)
        } else {
            row.select(&SEL_TOPIC_INFO)
                .next()
                .and_then(|info| {
                    let t = info.text().collect::<String>();
                    RE_TIME.captures(&t).map(|c| c[0].to_string())
                })
                .unwrap_or_default()
        };

        // comment count
        let reply = row
            .select(&SEL_COMMENT_GO)
            .next()
            .or_else(|| row.select(&SEL_COMMENT_FB).next())
            .and_then(|a| {
                let t = a.text().collect::<String>();
                RE_DIGITS.captures(&t).map(|c| c[1].to_string())
            })
            .unwrap_or_default();

        let url = format!("{base_url}/topic?id={id}");
        let info = format!("{author}\u{318D}{time}\u{318D}{points}P");

        out.push(RustListItem {
            id,
            title,
            reply,
            category,
            time,
            url,
            info,
            like: points,
            author,
        });
    }

    out
}

#[cfg(test)]
mod tests {
    use super::*;

    const SAMPLE: &str = r#"
        <div class='topic_row' data-topic-state-id='29587'>
          <div class=topictitle>
            <a href='https://example.com/x'>
              <h2 class='topic-title-heading'>샘플 제목</h2>
            </a>
            <span class=topicurl>(example.com)</span>
          </div>
          <div class='topicdesc'><a href='topic?id=29587'>설명...</a></div>
          <div class='topicinfo'>
            <span id='tp29587'>7</span> points by
            <a href='/@xguru'>xguru</a>
            <span title='2026-05-18 01:17'>3시간전</span> |
            <a href='topic?id=29587&go=comments'>댓글 2개</a>
          </div>
        </div>
    "#;

    #[test]
    fn parses_basic_row() {
        let items =
            parse_geek_news_list(SAMPLE.to_string(), "https://news.hada.io".to_string());
        assert_eq!(items.len(), 1);
        let it = &items[0];
        assert_eq!(it.id, 29587);
        assert_eq!(it.title, "샘플 제목");
        assert_eq!(it.author, "xguru");
        assert_eq!(it.like, "7");
        assert_eq!(it.reply, "2");
        assert_eq!(it.time, "3시간전");
        assert_eq!(it.url, "https://news.hada.io/topic?id=29587");
        assert_eq!(it.category, "(example.com)");
    }

    #[test]
    fn skips_rows_without_title() {
        let html = r#"<div class='topic_row'><div class='topicdesc'><a href='topic?id=1'>x</a></div></div>"#;
        let items = parse_geek_news_list(html.to_string(), "https://news.hada.io".to_string());
        assert!(items.is_empty());
    }
}
