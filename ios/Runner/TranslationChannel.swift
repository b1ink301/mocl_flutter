import SwiftUI
#if os(iOS)
import Flutter
import UIKit
#else
import FlutterMacOS
import AppKit
#endif
#if canImport(Translation)
import Translation
#endif

/// 기기 내 번역(Apple Translation). Dart 의 `PlatformTranslator` 와 짝을 이룬다.
///
/// `TranslationSession` 은 SwiftUI `.translationTask` 로만 받을 수 있어서(iOS 26 ·
/// macOS 26 전) 화면에 1pt 짜리 투명 SwiftUI 뷰를 붙여 두고 그 안에서 번역한다.
/// 언어 데이터가 없으면 시스템이 받을지 묻는 창을 띄운다.
/// iOS · macOS 가 같은 파일을 쓴다(`ios/Runner` · `macos/Runner` 에 같은 내용).
final class TranslationChannel: NSObject {
  static let name = "net.b1ink.mocl/translation"

  private let channel: FlutterMethodChannel
  private var bridge: AnyObject?

  init(messenger: FlutterBinaryMessenger) {
    channel = FlutterMethodChannel(name: Self.name, binaryMessenger: messenger)
    super.init()
    channel.setMethodCallHandler { [weak self] call, result in
      self?.handle(call, result: result)
    }
  }

  static var isSupported: Bool {
    #if canImport(Translation)
    if #available(iOS 18.0, macOS 15.0, *) { return true }
    #endif
    return false
  }

  private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "isSupported":
      result(Self.isSupported)
    case "translate":
      #if canImport(Translation)
      if #available(iOS 18.0, macOS 15.0, *) {
        let args = call.arguments as? [String: Any]
        let texts = args?["texts"] as? [String] ?? []
        let from = args?["from"] as? String ?? "en"
        let to = args?["to"] as? String ?? "ko"
        Task { @MainActor in
          guard let bridge = self.attachBridge() else {
            result(FlutterError(code: "failed", message: "번역 화면을 붙이지 못했어요.", details: nil))
            return
          }
          bridge.enqueue(texts: texts, from: from, to: to) { outcome in
            switch outcome {
            case .success(let translated):
              result(translated)
            case .failure(let error):
              result(FlutterError(code: "failed", message: error.localizedDescription, details: nil))
            }
          }
        }
        return
      }
      #endif
      result(FlutterError(code: "unsupported", message: "이 OS 버전은 번역을 지원하지 않아요.", details: nil))
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  #if canImport(Translation)
  /// 번역용 SwiftUI 뷰를 화면에 한 번만 붙인다.
  @available(iOS 18.0, macOS 15.0, *)
  @MainActor
  private func attachBridge() -> TranslationBridge? {
    if let bridge = bridge as? TranslationBridge { return bridge }
    let bridge = TranslationBridge()
    let rootView = TranslationHostView(bridge: bridge)
    #if os(iOS)
    let root = UIApplication.shared.connectedScenes
      .compactMap { ($0 as? UIWindowScene)?.keyWindow ?? ($0 as? UIWindowScene)?.windows.first }
      .first?.rootViewController
    guard let root else { return nil }
    let host = UIHostingController(rootView: rootView)
    host.view.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
    host.view.backgroundColor = .clear
    host.view.isUserInteractionEnabled = false
    root.addChild(host)
    root.view.addSubview(host.view)
    host.didMove(toParent: root)
    #else
    guard let contentView = (NSApp.mainWindow ?? NSApp.windows.first)?.contentView else { return nil }
    let host = NSHostingView(rootView: rootView)
    host.frame = NSRect(x: 0, y: 0, width: 1, height: 1)
    contentView.addSubview(host)
    #endif
    self.bridge = bridge
    return bridge
  }
  #endif
}

#if canImport(Translation)
@available(iOS 18.0, macOS 15.0, *)
@MainActor
final class TranslationBridge: ObservableObject {
  private struct Job {
    let texts: [String]
    let completion: (Result<[String], Error>) -> Void
  }

  @Published var configuration: TranslationSession.Configuration?
  private var jobs: [Job] = []
  private var isRunning = false

  func enqueue(
    texts: [String],
    from: String,
    to: String,
    completion: @escaping (Result<[String], Error>) -> Void
  ) {
    jobs.append(Job(texts: texts, completion: completion))
    // 도는 중이면 run 이 이어서 처리한다. 설정을 바꾸면 진행 중인 작업이 취소된다.
    if isRunning { return }
    let source = Locale.Language(identifier: from)
    let target = Locale.Language(identifier: to)
    if configuration?.source == source, configuration?.target == target {
      configuration?.invalidate()
    } else {
      configuration = TranslationSession.Configuration(source: source, target: target)
    }
  }

  func run(_ session: TranslationSession) async {
    isRunning = true
    defer { isRunning = false }
    while !jobs.isEmpty {
      let job = jobs.removeFirst()
      do {
        // 언어 데이터가 없으면 여기서 시스템이 받을지 묻는다.
        try await session.prepareTranslation()
        let requests = job.texts.enumerated().map {
          TranslationSession.Request(sourceText: $0.element, clientIdentifier: String($0.offset))
        }
        var translated = job.texts
        for response in try await session.translations(from: requests) {
          if let id = response.clientIdentifier, let index = Int(id) {
            translated[index] = response.targetText
          }
        }
        job.completion(.success(translated))
      } catch {
        job.completion(.failure(error))
      }
    }
  }
}

@available(iOS 18.0, macOS 15.0, *)
private struct TranslationHostView: View {
  @ObservedObject var bridge: TranslationBridge

  var body: some View {
    Color.clear
      .frame(width: 1, height: 1)
      .allowsHitTesting(false)
      .translationTask(bridge.configuration) { session in
        await bridge.run(session)
      }
  }
}
#endif
