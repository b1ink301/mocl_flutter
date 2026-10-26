package net.b1ink.mocl_flutter

import android.content.Context
import android.graphics.drawable.GradientDrawable
import android.view.Gravity
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.LinearLayout
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView

/**
 * 게시글 목록 행과 같은 모양의 네이티브 광고.
 *
 * 제목 한 줄 + (아이콘 · 본문 · "광고" 배지) 한 줄. 글자 크기 · 색 · 줄 높이는
 * Dart 의 `ListAdStyle` 이 `customOptions` 로 넘긴다. 높이는 Dart 가 같은 값으로
 * 미리 계산해 `AdWidget` 을 감싸므로, 여기서 각 줄의 높이를 그 값에 고정한다.
 */
class ListNativeAdFactory(context: Context) : BaseNativeAdFactory(context) {
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
        val badge = adBadge(o)
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
}
