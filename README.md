# mocl_flutter

A new Flutter project.

## Getting Started

## build_runner 실행

```shell
dart run build_runner build --delete-conflicting-outputs
```

## Run App

### prd

```shell
flutter run --flavor prd
```

```shell
flutter run --release --flavor prd
```

```shell
flutter run --profile --flavor prd
```

### dev

```shell
flutter run --flavor dev
```

```shell
flutter run --release --flavor dev
```

## 빌드 옵션

```shell
flutter build [appbundle|apk|ios|ipa] --flavor [dev|prd]
```

```shell
flutter clean
```

## Build Apk

### prd

```shell
flutter build apk --flavor prd
```

```shell
flutter build appbundle --flavor prd 
```

### dev

```shell
flutter build apk --flavor dev
```

## Build iOS

* XCode로 ios 프로젝트를 열어서, 인증서 세팅을 해줘야한다.

### cocopod 설정

```shell
cd ios
pod install
```

### prd

```shell
flutter build ipa --flavor prd
```

### dev

```shell
flutter build ipa --flavor dev
```

## Flavor 설정
* flavorizr.yaml 파일의 정의

```shell
dart run flutter_flavorizr
```

```shell
dart run flutter_flavorizr -p android:buildGradle # 특정 항목만..
```

json 변환 작업을 하기 위해서는 아래 명령어를 선행해야한다. 
$ dart run build_runner build --delete-conflicting-outputs       

$ flutter run --profile --cache-sksl --purge-persistent-cache --no-enable-impeller --flavor prd -t lib/main_prd.dart (Press M)
$ flutter build appbundle --bundle-sksl-path flutter_01.sksl.json --flavor prd -t lib/main_prd.dart
$ flutter config --jdk-dir "/usr/local/Cellar/openjdk@17/17.0.14/libexec/openjdk.jdk/Contents/Home"

$ dart run flutter_native_splash:create --path=./flutter_native_splash.yaml

flutter run flutter_flavorizr -p assets:download assets:extract ios:xcconfig assets:clean
flutter run flutter_flavorizr -p assets:download assets:extract -p google:firebase
dart pub global activate flutterfire_cli

v3.24.x
~/fvm/versions/3.24.5/bin/flutter run --profile --cache-sksl --purge-persistent-cache
~/fvm/versions/3.24.5/bin/flutter build appbundle --bundle-sksl-path flutter_02.sksl.json
~/fvm/versions/3.24.5/bin/dart run build_runner build --delete-conflicting-outputs
~/fvm/versions/3.24.5/bin/flutter run  
~/fvm/versions/3.24.5/bin/flutter pub get  

--no-enable-impeller --release