package net.b1ink.mocl_flutter

import android.os.Handler
import android.os.Looper
import com.google.android.gms.tasks.Tasks
import com.google.mlkit.common.model.DownloadConditions
import com.google.mlkit.nl.translate.TranslateLanguage
import com.google.mlkit.nl.translate.Translation
import com.google.mlkit.nl.translate.Translator
import com.google.mlkit.nl.translate.TranslatorOptions
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors

/**
 * 기기 내 번역(ML Kit Translation). Dart 의 `PlatformTranslator` 와 짝을 이룬다.
 *
 * 처음 번역할 때 언어 모델(언어마다 약 30MB)을 받고, 그 뒤로는 오프라인으로 동작한다.
 * ML Kit 의 Task 를 메인 스레드에서 기다리면 안 되므로 전용 스레드에서 차례로 처리한다.
 */
class TranslationChannel(messenger: BinaryMessenger) : MethodChannel.MethodCallHandler {
    private val channel = MethodChannel(messenger, CHANNEL)
    private val executor: ExecutorService = Executors.newSingleThreadExecutor()
    private val mainHandler = Handler(Looper.getMainLooper())
    private val translators = mutableMapOf<String, Translator>()

    init {
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "isSupported" -> result.success(true)
            "translate" -> translate(call, result)
            else -> result.notImplemented()
        }
    }

    private fun translate(call: MethodCall, result: MethodChannel.Result) {
        val texts = call.argument<List<String>>("texts") ?: emptyList()
        val source = TranslateLanguage.fromLanguageTag(call.argument<String>("from") ?: "en")
        val target = TranslateLanguage.fromLanguageTag(call.argument<String>("to") ?: "ko")
        if (source == null || target == null) {
            result.error("unsupported", "지원하지 않는 언어예요.", null)
            return
        }

        executor.execute {
            try {
                val translator = translators.getOrPut("$source>$target") {
                    Translation.getClient(
                        TranslatorOptions.Builder()
                            .setSourceLanguage(source)
                            .setTargetLanguage(target)
                            .build(),
                    )
                }
                Tasks.await(translator.downloadModelIfNeeded(DownloadConditions.Builder().build()))
                val translated = texts.map { text ->
                    if (text.isBlank()) text else Tasks.await(translator.translate(text))
                }
                mainHandler.post { result.success(translated) }
            } catch (e: Exception) {
                mainHandler.post { result.error("failed", e.message, null) }
            }
        }
    }

    fun dispose() {
        channel.setMethodCallHandler(null)
        executor.execute {
            translators.values.forEach { it.close() }
            translators.clear()
        }
        executor.shutdown()
    }

    companion object {
        const val CHANNEL = "net.b1ink.mocl/translation"
    }
}
