import AppKit
import ObjectiveC

class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    let defaults = UserDefaults.standard
    let shortcutCapture = ShortcutCapture.shared
    private var timer: Timer?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        NotificationCenter.default.addObserver(self, selector: #selector(windowWillClose), name: NSWindow.willCloseNotification, object: nil)
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        print("Приложение запущено!")
        
        _ = AppModel()
        
//        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
//            NotificationCenter.default.post(name: .pingNotification, object: nil)
//        }
    }
    
    @objc func windowWillClose(_ notification: Notification) {
        print("Окно закрыто!")
        // Здесь вы можете добавить дополнительные действия при закрытии окна
    }
    
}
