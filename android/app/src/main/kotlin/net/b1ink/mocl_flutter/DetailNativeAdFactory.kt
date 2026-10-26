package net.b1ink.mocl_flutter

import android.content.Context
import android.graphics.drawable.GradientDrawable
import android.view.Gravity
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.LinearLayout
import com.google.android.gms.ads.nativead.MediaView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import kotlin.math.max

/**
 * 글 상세의 본문과 댓글 사이에 넣는 카드형 네이티브 광고.
 *
 * (아이콘 · 제목 · "광고" 배지) / 대표 이미지 · 동영상(MediaView) / (설명 두 줄 · 행동 버튼).
 * 스타일과 미디어 높이는 Dart 의 `DetailAdStyle` 이 넘기고, 같은 값으로 전체 높이를
 * 미리 계산한다. 여백 상수는 `DetailAdStyle` 과 같아야 한다.
 */
class DetailNativeAdFactory(context: Context) : BaseNativeAdFactory(context) {
    companion object {
        const val FACTORY_ID = "detailCard"

        private const val PADDING_VERTICAL = 16f
        private const val SECTION_GAP = 10f
        private const val ICON_SIZE = 20f
        private const val ICON_GAP = 8f
        private const val CTA_HEIGHT = 32f
        private const val CTA_GAP = 10f
        private const val MEDIA_RADIUS = 10f

        // 오른쪽 위 AdChoices 아이콘과 배지가 겹치지 않게 비워 둔다.
        private const val TOP_ROW_END_INSET = 18f
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
            setPadding(0, dp(PADDING_VERTICAL), 0, dp(PADDING_VERTICAL))
        }

        // 1) 아이콘 · 제목 · 배지
        val badgeHeight = o.num("badgeLineHeight") + 3f
        val topRow = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
            setPadding(0, 0, dp(TOP_ROW_END_INSET), 0)
        }
        val icon = nativeAd.icon?.drawable
        if (icon != null) {
            val size = dp(ICON_SIZE)
            val iconView = ImageView(context).apply {
                setImageDrawable(icon)
                scaleType = ImageView.ScaleType.CENTER_CROP
                clipToOutline = true
                background = GradientDrawable().apply { cornerRadius = dp(5f).toFloat() }
            }
            topRow.addView(iconView, LinearLayout.LayoutParams(size, size).apply { marginEnd = dp(ICON_GAP) })
            adView.iconView = iconView
        }
        val headline = textView(o, "title").apply { text = nativeAd.headline }
        topRow.addView(headline, LinearLayout.LayoutParams(0, dp(o.num("titleLineHeight")), 1f))
        adView.headlineView = headline
        topRow.addView(
            adBadge(o),
            LinearLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, dp(badgeHeight))
                .apply { marginStart = dp(ICON_GAP) },
        )
        val topRowHeight = max(max(o.num("titleLineHeight"), ICON_SIZE), badgeHeight)
        column.addView(topRow, LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, dp(topRowHeight)))

        // 2) 대표 이미지 · 동영상. 잘라내지 않고 칸 안에 맞춘다.
        val mediaView = MediaView(context).apply {
            setImageScaleType(ImageView.ScaleType.FIT_CENTER)
            clipToOutline = true
            background = GradientDrawable().apply {
                cornerRadius = dp(MEDIA_RADIUS).toFloat()
                setColor(o.color("mediaBackground"))
            }
        }
        column.addView(
            mediaView,
            LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, dp(o.num("mediaHeight")))
                .apply { topMargin = dp(SECTION_GAP) },
        )
        adView.mediaView = mediaView

        // 3) 설명 두 줄 · 행동 버튼
        val smallLines = o.num("smallLineHeight") * 2
        val bottomRow = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
        }
        val info = textView(o, "small", lines = 2)
        val body = nativeAd.body
        if (!body.isNullOrBlank()) {
            info.text = body
            adView.bodyView = info
        } else {
            info.text = nativeAd.advertiser.orEmpty()
            adView.advertiserView = info
        }
        bottomRow.addView(info, LinearLayout.LayoutParams(0, dp(smallLines), 1f))

        val callToAction = nativeAd.callToAction
        if (!callToAction.isNullOrBlank()) {
            val cta = textView(o, "cta").apply {
                text = callToAction
                gravity = Gravity.CENTER
                setPadding(dp(14f), 0, dp(14f), 0)
                background = pill(o.color("ctaBackground"))
            }
            bottomRow.addView(
                cta,
                LinearLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, dp(CTA_HEIGHT))
                    .apply { marginStart = dp(CTA_GAP) },
            )
            adView.callToActionView = cta
        }
        val bottomRowHeight = max(smallLines, CTA_HEIGHT)
        column.addView(
            bottomRow,
            LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, dp(bottomRowHeight))
                .apply { topMargin = dp(SECTION_GAP) },
        )

        adView.addView(column, ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT))
        adView.setNativeAd(nativeAd)
        return adView
    }
}
