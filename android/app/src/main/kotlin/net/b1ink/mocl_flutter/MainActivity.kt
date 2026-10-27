package net.b1ink.mocl_flutter

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
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
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, ListNativeAdFactory.FACTORY_ID)
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, DetailNativeAdFactory.FACTORY_ID)
        super.cleanUpFlutterEngine(flutterEngine)
    }
}
