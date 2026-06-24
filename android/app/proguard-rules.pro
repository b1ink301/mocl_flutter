## Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

# Firebase 관련 규칙
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Google Sign-In v7 (Credential Manager / Google Identity) 관련 규칙
-keep class com.google.android.gms.auth.** { *; }
-keep class com.google.android.gms.common.** { *; }
-keep class com.google.android.libraries.identity.googleid.** { *; }
-keep class androidx.credentials.** { *; }
-dontwarn com.google.android.gms.**
-dontwarn androidx.credentials.**

# Pigeon 관련 규칙 (Firebase 등에서 사용)
-keep class dev.flutter.pigeon.** { *; }

# Retrofit 관련 규칙
-keep class retrofit2.** { *; }
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn retrofit2.**

# Gson 관련 규칙
-keep class com.google.gson.** { *; }
-keepattributes *Annotation*

# XML 관련 규칙
-dontwarn org.xmlpull.v1.**
-dontwarn org.kxml2.io.**
-dontwarn android.content.res.**
-dontwarn org.slf4j.impl.StaticLoggerBinder

-keep class org.xmlpull.** { *; }
-keepclassmembers class org.xmlpull.** { *; }

# 특정 클래스 난독화 방지
-keep class kr.b1ink.mocl.MainActivity { *; }

-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication

# Retrofit does reflection on generic parameters. InnerClasses is required to use Signature and
# EnclosingMethod is required to use InnerClasses.
-keepattributes Signature, InnerClasses, EnclosingMethod

# Retrofit does reflection on method and parameter annotations.
-keepattributes RuntimeVisibleAnnotations, RuntimeVisibleParameterAnnotations

# Keep annotation default values (e.g., retrofit2.http.Field.encoded).
-keepattributes AnnotationDefault

# Retain service method parameters when optimizing.
-keepclassmembers,allowshrinking,allowobfuscation interface * {
    @retrofit2.http.* <methods>;
}

# Ignore annotation used for build tooling.
-dontwarn org.codehaus.mojo.animal_sniffer.IgnoreJRERequirement

# Ignore JSR 305 annotations for embedding nullability information.
-dontwarn javax.annotation.**

# Guarded by a NoClassDefFoundError try/catch and only used when on the classpath.
-dontwarn kotlin.Unit

# Top-level functions that can only be used by Kotlin.
-dontwarn retrofit2.KotlinExtensions
-dontwarn retrofit2.KotlinExtensions$*

# With R8 full mode, it sees no subtypes of Retrofit interfaces since they are created with a Proxy
# and replaces all potential values with null. Explicitly keeping the interfaces prevents this.
-if interface * { @retrofit2.http.* <methods>; }
-keep,allowobfuscation interface <1>

# Keep inherited services.
-if interface * { @retrofit2.http.* <methods>; }
-keep,allowobfuscation interface * extends <1>

# Keep generic signature of Call, Response (R8 full mode strips signatures from non-kept items).
-keep,allowobfuscation,allowshrinking interface retrofit2.Call
-keep,allowobfuscation,allowshrinking class retrofit2.Response

# With R8 full mode generic signatures are stripped for classes that are not
# kept. Suspend functions are wrapped in continuations where the type argument
# is used.
-keep,allowobfuscation,allowshrinking class kotlin.coroutines.Continuation

-keep public class com.navercorp.nid.** {
    public *;
}

-dontwarn com.github.dart_lang.jni.JniPlugin
-dontwarn com.github.dart_lang.jni_flutter.JniFlutterPlugin
-dontwarn com.ryanheise.audio_session.AudioSessionPlugin
-dontwarn com.ryanheise.just_audio.JustAudioPlugin
-dontwarn com.tekartik.sqflite.SqflitePlugin
-dontwarn dev.fluttercommunity.plus.packageinfo.PackageInfoPlugin
-dontwarn dev.fluttercommunity.plus.share.SharePlusPlugin
-dontwarn dev.fluttercommunity.plus.wakelock.WakelockPlusPlugin
-dontwarn io.flutter.plugins.firebase.core.FlutterFirebaseCorePlugin
-dontwarn io.flutter.plugins.firebase.crashlytics.FlutterFirebaseCrashlyticsPlugin
-dontwarn io.flutter.plugins.googlesignin.GoogleSignInPlugin
-dontwarn io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin
-dontwarn io.flutter.plugins.urllauncher.UrlLauncherPlugin
-dontwarn io.flutter.plugins.videoplayer.VideoPlayerPlugin
-dontwarn io.flutter.plugins.webviewflutter.WebViewFlutterPlugin
-dontwarn io.github.ponnamkarthik.toast.fluttertoast.FlutterToastPlugin

-keepattributes *
-keepattributes *Annotation*
-keepattributes *Invisible*

-keepattributes RuntimeInvisibleAnnotations,
                RuntimeInvisibleParameterAnnotations,
                RuntimeInvisibleTypeAnnotations
