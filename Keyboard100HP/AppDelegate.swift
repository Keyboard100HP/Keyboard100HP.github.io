import AppKit
import ObjectiveC

class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    let defaults = UserDefaults.standard
    let shortcutCapture = ShortcutCapture.shared
    var updateManager = UpdateManager.shared
    
    private var timer: Timer?

    func applicationDidFinishLaunching(_ notification: Notification) {
        print("Приложение запущено!")
        
        _ = AppModel()
    }
}
