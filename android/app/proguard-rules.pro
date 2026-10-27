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
# Pigeon(dev.flutter.pigeon.**) 은 이 앱의 의존성에서 생성되지 않음 (매칭 0건).
# 둘 다 R8 구성 분석기 결과에 따라 제거됨.

-dontwarn io.flutter.embedding.**

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
