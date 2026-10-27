package net.b1ink.mocl_flutter

import android.content.Context
import android.graphics.Typeface
import android.graphics.drawable.GradientDrawable
import android.os.Build
import android.text.TextUtils
import android.util.TypedValue
import android.view.Gravity
import android.view.View
import android.widget.TextView
import io.flutter.FlutterInjector
import io.flutter.plugins.googlemobileads.NativeAdFactory
import kotlin.math.roundToInt

/**
 * 앱 화면과 같은 글꼴 · 색으로 네이티브 광고를 그리는 팩토리들의 공통 도우미.
 *
 * 글자 크기 · 색 · 줄 높이는 Dart 쪽 스타일이 `customOptions` 로 넘긴다.
 * Dart 가 같은 값으로 광고 높이를 미리 계산하므로, 각 줄의 높이는 넘어온 값에 고정한다.
 */
abstract class BaseNativeAdFactory(protected val context: Context) : NativeAdFactory {
    private val typefaces = HashMap<Int, Typeface>()

    /**
     * `{prefix}Size` · `{prefix}Color` · `{prefix}Weight` 로 꾸민 텍스트. 기본은 한 줄.
     * 높이는 부르는 쪽이 `{prefix}LineHeight` × 줄 수로 고정한다.
     */
    protected fun textView(o: Map<String, Any>, prefix: String, lines: Int = 1) = TextView(context).apply {
        setTextSize(TypedValue.COMPLEX_UNIT_DIP, o.num("${prefix}Size"))
        setTextColor(o.color("${prefix}Color"))
        typeface = pretendard(o.num("${prefix}Weight").toInt())
        includeFontPadding = false
        maxLines = lines
        isSingleLine = lines == 1
        ellipsize = TextUtils.TruncateAt.END
        gravity = if (lines == 1) Gravity.CENTER_VERTICAL else Gravity.TOP
        textAlignment = View.TEXT_ALIGNMENT_VIEW_START
    }

    /** 광고임을 밝히는 "광고" 배지(Ad attribution). 목록의 답글 배지와 같은 모양. */
    protected fun adBadge(o: Map<String, Any>) = textView(o, "badge").apply {
        text = "광고"
        val padH = dp(7f)
        val padV = dp(1.5f)
        setPadding(padH, padV, padH, padV)
        background = pill(o.color("badgeBackground"))
    }

    protected fun pill(color: Int) = GradientDrawable().apply {
        cornerRadius = dp(999f).toFloat()
        setColor(color)
    }

    /**
     * Flutter 에셋으로 번들된 Pretendard 가변 폰트를 그대로 쓴다. 굵기마다 한 번만 만든다.
     * 가변 축 지정(`wght`)은 API 26 부터라, 그 아래는 기본 굵기(400)에 굵은 글꼴만 흉내 낸다.
     */
    protected fun pretendard(weight: Int): Typeface = typefaces.getOrPut(weight) {
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

    protected fun dp(value: Float): Int =
        TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, value, context.resources.displayMetrics).roundToInt()

    protected fun Map<String, Any>.num(key: String): Float = (this[key] as? Number)?.toFloat() ?: 0f

    // Dart 의 ARGB 는 32비트 부호 없는 값이라 Long 으로 넘어온다.
    protected fun Map<String, Any>.color(key: String): Int = (this[key] as? Number)?.toInt() ?: 0
}
