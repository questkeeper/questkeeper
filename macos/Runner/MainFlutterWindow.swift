import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()

    // Create a frame with specific dimensions, centered on screen
    let screenFrame = NSScreen.main?.frame ?? self.frame
    let windowFrame = NSRect(
      x: (screenFrame.width - 1000) / 2,
      y: (screenFrame.height - 800) / 2,
      width: 1000,
      height: 800
    )

    self.contentViewController = flutterViewController

    // Set autosave name to enable window state persistence
    self.setFrameAutosaveName("MainWindow")

    // If there's no saved frame, use the default frame
    if !self.setFrameUsingName("MainWindow") {
      self.setFrame(windowFrame, display: true)
    }

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
