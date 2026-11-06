package net.b1ink.mocl_flutter

import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class MainActivity: FlutterActivity() {
    private var translationChannel: TranslationChannel? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        createKeywordAlertChannel()
    }

    /// 키워드 알림 채널. 서버(server/)가 FCM 메시지에 같은 id 를 넣고,
    /// 매니페스트의 default_notification_channel_id 도 이 값이다.
    /// 이미 있으면 시스템이 무시하므로 매번 불러도 된다(사용자가 바꾼 설정은 유지).
    private fun createKeywordAlertChannel() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val channel = NotificationChannel(
            KEYWORD_ALERT_CHANNEL_ID,
            "키워드 알림",
            NotificationManager.IMPORTANCE_HIGH,
        ).apply { description = "구독한 게시판에 키워드가 들어간 새 글이 올라오면 알려 줍니다." }
        getSystemService(NotificationManager::class.java)?.createNotificationChannel(channel)
    }

    companion object {
        private const val KEYWORD_ALERT_CHANNEL_ID = "keyword_alerts"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        translationChannel = TranslationChannel(flutterEngine.dartExecutor.binaryMessenger)
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            ListNativeAdFactory.FACTORY_ID,
            ListNativeAdFactory(this),
        )
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            DetailNativeAdFactory.FACTORY_ID,
            DetailNativeAdFactory(this),
        )
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            DetailSmallNativeAdFactory.FACTORY_ID,
            DetailSmallNativeAdFactory(this),
        )
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        translationChannel?.dispose()
        translationChannel = null
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, ListNativeAdFactory.FACTORY_ID)
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, DetailNativeAdFactory.FACTORY_ID)
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, DetailSmallNativeAdFactory.FACTORY_ID)
        super.cleanUpFlutterEngine(flutterEngine)
    }
}
