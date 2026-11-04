import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  private var translationChannel: TranslationChannel?

  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)
    translationChannel = TranslationChannel(
      messenger: flutterViewController.engine.binaryMessenger)

    super.awakeFromNib()
  }
}
