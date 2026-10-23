# ============================================================
# mocl_flutter — R8 / ProGuard 규칙
#
# 원칙
#  1. 라이브러리가 AAR/JAR 에 번들한 consumer 규칙을 신뢰한다.
#     (Firebase, GMS, AndroidX, Flutter 플러그인 등은 수동 keep 불필요)
#  2. 리플렉션 / JNI 경계만 최소 범위로 keep 한다.
#  3. 패키지 와일드카드(`package.** { *; }`) 는 최후의 수단으로만 쓴다.
#
# 규칙을 추가하기 전에 "정말 리플렉션으로 접근되는가?" 를 먼저 확인할 것.
# ============================================================

# ------------------------------------------------------------
# Flutter 엔진
# ------------------------------------------------------------
# MethodChannel / EventChannel 등 플랫폼 채널 공용 타입
-keep class io.flutter.plugin.common.** { *; }

# FlutterJNI 는 @androidx.annotation.Keep 이 붙어 있어
# androidx-annotations.pro 의 `-keep @androidx.annotation.Keep class * {*;}` 로 이미 보존됨.
# Pigeon(dev.flutter.pigeon.**) 패키지 클래스는 이 앱의 의존성에서 생성되지 않음 (매칭 0건).
# 둘 다 R8 구성 분석기 결과에 따라 제거됨.
# 단, JNI 방식 Pigeon(shared_preferences_android 2.5.x 등)은 Dart 가 Java 타입을
# 이름 문자열로 찾는다 — 아래 "package:jni" 항목 참고. 플러그인을 들일 때
#   grep -rhoE "JClass\.forName\('[^']+'\)" ~/.pub-cache/hosted/pub.dev/<플러그인>/lib/
# 로 새로 keep 해야 할 타입이 있는지 확인한다.

-dontwarn io.flutter.embedding.**

# ------------------------------------------------------------
# package:jni — Kotlin suspend 함수의 JNI 호출 경계
# (shared_preferences_android 2.5.x 등 Pigeon 의 직접 JNI 바인딩)
#
# Dart 쪽은 `JClass.forName('kotlin/coroutines/Continuation')` 처럼
# **클래스 이름 문자열로** 조회한다. R8 은 이 참조를 볼 수 없어
# Continuation 을 `qu` 로 줄이거나 CoroutineSingletons 를 통째로
# 제거하고, 런타임에 NoSuchMethodError / ClassNotFoundException 이
# 난다. 그 예외는 `SharedPreferences.getInstance()` 를 영원히 끝나지
# 않게 만들어 앱이 스플래시에서 멈춘다.
#
# 목록은 `fvm dart run tool/check_jni_keep.dart` 가 release 빌드의 mapping.txt
# 와 대조해 찾는다(tool/release_smoke_test.sh 에서 자동 실행). 플러그인을
# 올리거나 들인 뒤 이 검사가 실패하면 여기에 추가한다.
# ------------------------------------------------------------
# jni 코루틴 지원 — 이게 빠지면 SharedPreferences.getInstance() 에서 멈춘다
-keep class kotlin.Result { *; }
-keep class kotlin.Result$Failure { *; }
-keep class kotlin.Unit { *; }
-keep class kotlin.coroutines.Continuation { *; }
-keep class kotlin.coroutines.intrinsics.CoroutineSingletons { *; }
-keep class kotlin.coroutines.intrinsics.IntrinsicsKt { *; }

# 바인딩이 이름으로 참조하지만 지금 쓰는 경로에선 불리지 않는 타입.
# (SharedPreferencesAsync 등 다른 API 를 쓰기 시작하면 바로 필요해진다)
-keep class kotlin.jvm.internal.DefaultConstructorMarker { *; }
-keep class kotlin.enums.EnumEntries { *; }
-keep class io.flutter.plugins.sharedpreferences.** { *; }
-keep class io.flutter.embedding.engine.plugins.FlutterPlugin$FlutterPluginBinding { *; }
-keep class io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding { *; }

# ------------------------------------------------------------
# google_mobile_ads(play-services-ads) → work-runtime 2.7.0 → room-runtime 2.2.5
#
# 이 Room 은 consumer keep 규칙이 없어 R8 이 `WorkDatabase_Impl` 의 기본
# 생성자를 지운다. Room 은 그 클래스를 이름으로 찾아 리플렉션으로 만들기
# 때문에, 앱 시작 시 androidx.startup 의 WorkManager 초기화에서
# "Failed to create an instance of androidx.work.impl.WorkDatabase" 로 죽는다.
# ------------------------------------------------------------
-keep class * extends androidx.room.RoomDatabase { void <init>(); }

# Deferred components 용 Play Core — 이 앱은 사용하지 않음
-dontwarn com.google.android.play.core.**

# ------------------------------------------------------------
# Firebase Crashlytics
# 난독화된 릴리스 스택트레이스를 복원하려면 소스/라인 정보가 필요하다.
# (mapping.txt 업로드와 함께 동작)
# ------------------------------------------------------------
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile

# ------------------------------------------------------------
# Google Sign-In v7 (Credential Manager + Google Identity)
# CredentialManager 는 provider 를 통해 요청/응답 타입을
# 리플렉션으로 복원하므로 해당 타입만 명시적으로 유지한다.
# ------------------------------------------------------------
-keep class com.google.android.libraries.identity.googleid.GetGoogleIdOption { *; }
-keep class com.google.android.libraries.identity.googleid.GetSignInWithGoogleOption { *; }
-keep class com.google.android.libraries.identity.googleid.GoogleIdTokenCredential { *; }

# ------------------------------------------------------------
# 보존 속성
#   Signature / InnerClasses / EnclosingMethod : 제네릭 타입 정보
#   *Annotation*                               : 런타임 애노테이션 조회
# `-keepattributes *` 는 절대 쓰지 말 것 (DEX 메타데이터가 크게 늘어남)
# ------------------------------------------------------------
-keepattributes Signature, InnerClasses, EnclosingMethod
-keepattributes *Annotation*

# ------------------------------------------------------------
# XML 파서 — 플랫폼 제공 클래스라 keep 은 불필요, 경고만 억제
# ------------------------------------------------------------
-dontwarn org.xmlpull.v1.**
-dontwarn org.kxml2.io.**
-dontwarn org.slf4j.impl.StaticLoggerBinder
-dontwarn javax.annotation.**
