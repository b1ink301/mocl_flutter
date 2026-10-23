package net.b1ink.mocl_flutter

import android.content.Context
import android.graphics.Typeface
import android.graphics.drawable.GradientDrawable
import android.os.Build
import android.text.TextUtils
import android.util.TypedValue
import android.view.Gravity
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.FlutterInjector
import io.flutter.plugins.googlemobileads.NativeAdFactory
import kotlin.math.roundToInt

/**
 * 게시글 목록 행과 같은 모양의 네이티브 광고.
 *
 * 제목 한 줄 + (아이콘 · 본문 · "광고" 배지) 한 줄. 글자 크기 · 색 · 줄 높이는
 * Dart 의 `ListAdStyle` 이 `customOptions` 로 넘긴다. 높이는 Dart 가 같은 값으로
 * 미리 계산해 `AdWidget` 을 감싸므로, 여기서 각 줄의 높이를 그 값에 고정한다.
 */
class ListNativeAdFactory(private val context: Context) : NativeAdFactory {
    companion object {
        const val FACTORY_ID = "listTile"

        private const val PADDING_START = 16f
        private const val PADDING_END = 10f
        private const val PADDING_VERTICAL = 14f
        private const val ROW_GAP = 8f
        private const val ICON_GAP = 6f

        // 오른쪽 위 AdChoices 아이콘과 제목이 겹치지 않게 비워 둔다.
        private const val HEADLINE_END_INSET = 18f
    }

    private val typefaces = HashMap<Int, Typeface>()

    override fun createNativeAd(
        nativeAd: NativeAd,
        customOptions: MutableMap<String, Any>?,
    ): NativeAdView {
        val o = customOptions.orEmpty()
        val adView = NativeAdView(context)
        adView.setBackgroundColor(o.color("background"))

        val column = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            setPadding(dp(PADDING_START), dp(PADDING_VERTICAL), dp(PADDING_END), dp(PADDING_VERTICAL))
        }

        val headline = textView(o, "title").apply {
            text = nativeAd.headline
            setPadding(0, 0, dp(HEADLINE_END_INSET), 0)
        }
        column.addView(headline, LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, dp(o.num("titleLineHeight"))))
        adView.headlineView = headline

        val row = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
        }

        val icon = nativeAd.icon?.drawable
        if (icon != null) {
            val size = dp(o.num("iconSize"))
            val iconView = ImageView(context).apply {
                setImageDrawable(icon)
                scaleType = ImageView.ScaleType.CENTER_CROP
                clipToOutline = true
                background = GradientDrawable().apply { cornerRadius = size / 2f }
            }
            row.addView(iconView, LinearLayout.LayoutParams(size, size).apply { marginEnd = dp(ICON_GAP) })
            adView.iconView = iconView
        }

        // 목록의 "작성자 · 시간" 자리. 본문이 없으면 광고주 이름을 보인다.
        val info = textView(o, "small")
        val body = nativeAd.body
        if (!body.isNullOrBlank()) {
            info.text = body
            adView.bodyView = info
        } else {
            info.text = nativeAd.advertiser.orEmpty()
            adView.advertiserView = info
        }
        row.addView(info, LinearLayout.LayoutParams(0, dp(o.num("smallLineHeight")), 1f))

        // 목록의 답글 배지 자리. 광고임을 밝히는 표시(Ad attribution)를 겸한다.
        val badge = textView(o, "badge").apply {
            text = "광고"
            val padH = dp(7f)
            val padV = dp(1.5f)
            setPadding(padH, padV, padH, padV)
            background = GradientDrawable().apply {
                cornerRadius = dp(999f).toFloat()
                setColor(o.color("badgeBackground"))
            }
        }
        row.addView(
            badge,
            LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT,
                dp(o.num("badgeLineHeight") + 3f),
            ).apply { marginStart = dp(ICON_GAP) },
        )

        column.addView(
            row,
            LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT)
                .apply { topMargin = dp(ROW_GAP) },
        )

        adView.addView(column, ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT))
        adView.setNativeAd(nativeAd)
        return adView
    }

    /** `{prefix}Size` · `{prefix}Color` · `{prefix}Weight` 로 꾸민 한 줄짜리 텍스트. */
    private fun textView(o: Map<String, Any>, prefix: String) = TextView(context).apply {
        setTextSize(TypedValue.COMPLEX_UNIT_DIP, o.num("${prefix}Size"))
        setTextColor(o.color("${prefix}Color"))
        typeface = pretendard(o.num("${prefix}Weight").toInt())
        includeFontPadding = false
        maxLines = 1
        isSingleLine = true
        ellipsize = TextUtils.TruncateAt.END
        gravity = Gravity.CENTER_VERTICAL
        textAlignment = View.TEXT_ALIGNMENT_VIEW_START
    }

    /**
     * Flutter 에셋으로 번들된 Pretendard 가변 폰트를 그대로 쓴다. 굵기마다 한 번만 만든다.
     * 가변 축 지정(`wght`)은 API 26 부터라, 그 아래는 기본 굵기(400)에 굵은 글꼴만 흉내 낸다.
     */
    private fun pretendard(weight: Int): Typeface = typefaces.getOrPut(weight) {
        runCatching {
            val key = FlutterInjector.instance().flutterLoader()
                .getLookupKeyForAsset("fonts/pretendard/PretendardVariable.ttf")
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                Typeface.Builder(context.assets, key)
                    .setFontVariationSettings("'wght' $weight")
                    .setWeight(weight)
                    .build()
            } else {
                val base = Typeface.createFromAsset(context.assets, key)
                if (weight >= 600) Typeface.create(base, Typeface.BOLD) else base
            }
        }.getOrDefault(Typeface.DEFAULT)
    }

    private fun dp(value: Float): Int =
        TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, value, context.resources.displayMetrics).roundToInt()

    private fun Map<String, Any>.num(key: String): Float = (this[key] as? Number)?.toFloat() ?: 0f

    // Dart 의 ARGB 는 32비트 부호 없는 값이라 Long 으로 넘어온다.
    private fun Map<String, Any>.color(key: String): Int = (this[key] as? Number)?.toInt() ?: 0
}
