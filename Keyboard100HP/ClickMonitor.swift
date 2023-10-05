import Cocoa

class ClickMonitor {
    private var globalMonitor: Any?
//    private var hendler: () -> Void
    
    func startGlobalMonitoring(hendler: @escaping () -> Void) {
        globalMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { event in
            // Обработка глобального события
            hendler()
        }
    }
    
    func stopGlobalMonitoring() {
        if let globalMonitor = globalMonitor {
            NSEvent.removeMonitor(globalMonitor)
            self.globalMonitor = nil
        }
    }
}
