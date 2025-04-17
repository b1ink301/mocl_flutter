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