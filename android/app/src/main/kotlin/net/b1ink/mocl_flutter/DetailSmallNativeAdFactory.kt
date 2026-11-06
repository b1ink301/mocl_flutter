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

/**
 * 글 상세의 작은 네이티브 광고(small).
 *
 * 왼쪽 정사각 MediaView(120dp) / 오른쪽 (제목 두 줄 · 설명 한 줄 · ("광고" 배지 · 행동 버튼)).
 * 스타일과 칸 높이(`contentHeight`)는 Dart 의 `DetailSmallAdStyle` 이 넘긴다.
 * 여백 상수는 `DetailSmallAdStyle` 과 같아야 한다.
 */
class DetailSmallNativeAdFactory(context: Context) : BaseNativeAdFactory(context) {
    companion object {
        const val FACTORY_ID = "detailSmall"

        private const val PADDING_VERTICAL = 12f
        private const val MEDIA_SIZE = 120f
        private const val MEDIA_GAP = 12f
        private const val MEDIA_RADIUS = 10f
        private const val TEXT_GAP = 4f
        private const val CTA_HEIGHT = 32f

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

        val contentHeight = dp(o.numOr("contentHeight", MEDIA_SIZE))
        val row = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            setPadding(0, dp(PADDING_VERTICAL), 0, dp(PADDING_VERTICAL))
        }

        // 1) 정사각 미디어. 잘라내지 않고 칸 안에 맞춘다.
        val mediaView = MediaView(context).apply {
            setImageScaleType(ImageView.ScaleType.FIT_CENTER)
            clipToOutline = true
            background = GradientDrawable().apply {
                cornerRadius = dp(MEDIA_RADIUS).toFloat()
                setColor(o.color("mediaBackground"))
            }
        }
        val mediaSize = dp(MEDIA_SIZE)
        row.addView(
            mediaView,
            LinearLayout.LayoutParams(mediaSize, mediaSize).apply { marginEnd = dp(MEDIA_GAP) },
        )
        adView.mediaView = mediaView

        // 2) 제목 두 줄 · 설명 한 줄 · (배지 · 버튼)
        val column = LinearLayout(context).apply { orientation = LinearLayout.VERTICAL }

        val headline = textView(o, "title", lines = 2).apply {
            text = nativeAd.headline
            setPadding(0, 0, dp(HEADLINE_END_INSET), 0)
        }
        column.addView(
            headline,
            LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, dp(o.num("titleLineHeight") * 2)),
        )
        adView.headlineView = headline

        val info = textView(o, "small")
        val body = nativeAd.body
        if (!body.isNullOrBlank()) {
            info.text = body
            adView.bodyView = info
        } else {
            info.text = nativeAd.advertiser.orEmpty()
            adView.advertiserView = info
        }
        column.addView(
            info,
            LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, dp(o.num("smallLineHeight")))
                .apply { topMargin = dp(TEXT_GAP) },
        )

        // 남는 높이는 설명과 아래 줄 사이에 둔다(아래 줄은 미디어 바닥에 맞춘다).
        column.addView(View(context), LinearLayout.LayoutParams(0, 0, 1f))

        val bottomRow = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
        }
        bottomRow.addView(
            adBadge(o),
            LinearLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, dp(o.num("badgeLineHeight") + 3f)),
        )
        bottomRow.addView(View(context), LinearLayout.LayoutParams(0, 0, 1f))
        val callToAction = nativeAd.callToAction
        if (!callToAction.isNullOrBlank()) {
            val cta = textView(o, "cta").apply {
                text = callToAction
                gravity = Gravity.CENTER
                setPadding(dp(14f), 0, dp(14f), 0)
                background = pill(o.color("ctaBackground"))
            }
            bottomRow.addView(cta, LinearLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, dp(CTA_HEIGHT)))
            adView.callToActionView = cta
        }
        val bottomRowHeight = maxOf(CTA_HEIGHT, o.num("badgeLineHeight") + 3f)
        column.addView(
            bottomRow,
            LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, dp(bottomRowHeight)),
        )

        row.addView(column, LinearLayout.LayoutParams(0, contentHeight, 1f))

        adView.addView(row, ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT))
        adView.setNativeAd(nativeAd)
        return adView
    }
}
