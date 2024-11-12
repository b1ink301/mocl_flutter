# mocl_flutter

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


json 변환 작업을 하기 위해서는 아래 명령어를 선행해야한다. 
$ dart run build_runner build --delete-conflicting-outputs       

$ flutter run --profile --cache-sksl --purge-persistent-cache (M)
$ flutter build appbundle --bundle-sksl-path flutter_01.sksl.json
$ flutter config --jdk-dir "/usr/local/Cellar/openjdk@17/17.0.13/libexec/openjdk.jdk/Contents/Home"

$ dart run flutter_native_splash:create --path=./flutter_native_splash.yaml