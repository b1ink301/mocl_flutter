package net.b1ink.mocl_flutter

import android.content.Intent
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * 다른 앱에서 "공유" 로 보낸 글자(보통 글 링크)를 Dart 의 `SharedTextChannel` 로 넘긴다.
 *
 * - 앱이 꺼져 있다가 공유로 켜지면 Dart 가 아직 듣지 않으므로 [pending] 에 두고,
 *   Dart 가 준비되면 `takeInitial` 로 가져간다(한 번만).
 * - 이미 떠 있을 때 온 공유(`onNewIntent`)는 `onShared` 로 바로 보낸다.
 */
class ShareChannel(messenger: BinaryMessenger) : MethodChannel.MethodCallHandler {
    private val channel = MethodChannel(messenger, CHANNEL)
    private var pending: String? = null

    init {
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "takeInitial" -> {
                result.success(pending)
                pending = null
            }
            else -> result.notImplemented()
        }
    }

    /** 앱을 켠 인텐트. Dart 가 `takeInitial` 로 가져간다. */
    fun handleInitial(intent: Intent?) {
        sharedText(intent)?.let { pending = it }
    }

    /** 떠 있는 동안 온 인텐트. 공유면 true(소비함). */
    fun handleNew(intent: Intent?): Boolean {
        val text = sharedText(intent) ?: return false
        channel.invokeMethod("onShared", text)
        return true
    }

    fun dispose() {
        channel.setMethodCallHandler(null)
        pending = null
    }

    private fun sharedText(intent: Intent?): String? {
        if (intent?.action != Intent.ACTION_SEND) return null
        if (intent.type?.startsWith("text/") != true) return null
        // 브라우저는 EXTRA_TEXT 에 주소를, 일부 앱은 제목 + 주소를 함께 넣는다.
        val text = intent.getStringExtra(Intent.EXTRA_TEXT)
            ?: intent.getStringExtra(Intent.EXTRA_SUBJECT)
        return text?.takeIf { it.isNotBlank() }
    }

    companion object {
        const val CHANNEL = "net.b1ink.mocl/share"
    }
}
