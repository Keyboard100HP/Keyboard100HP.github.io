import SwiftUI
import Carbon
import Combine

class AppModel: ObservableObject {
    @ObservedObject var shortcutCapture = ShortcutCapture.shared
    var cancellables = Set<AnyCancellable>()
    var clickMonitor = ClickMonitor()
    var timeKeyDown: Date?
    
    init() {
        shortcutCapture.bindHandler(handle: { keyData in
            if (
                !self.shortcutCapture.isRecord &&
                self.shortcutCapture.isMonitoring &&
                !self.shortcutCapture.activeShortcutNames.isEmpty
            ) {
                let isDown = keyData.2 == "keyDown";
                let isTrigger = self.arraysHaveSameElements(self.shortcutCapture.activeShortcutNames, self.shortcutCapture.presedShortcutNames)
                
                if (self.shortcutCapture.activeShortcutNames.count == 1) {
                    let isFastShortcutListening = isTrigger && isDown;
                    let isFastShortcutFinishing = self.timeKeyDown != nil
                    let isFastShortcutCanceling = isFastShortcutFinishing && self.shortcutCapture.presedShortcutNames.count > 1
                    
                    if (isFastShortcutCanceling) {
                        self.timeKeyDown = nil
                        return false
                    }
                    
                    if (isFastShortcutListening) {
                        self.timeKeyDown = Date()
                        return false
                    }

                    if (isFastShortcutFinishing) {
                        let timeKeyDown = self.timeKeyDown!
                        self.timeKeyDown = nil
                        
                        if (timeKeyDown > Date().addingTimeInterval(-0.75)) {
                            return self.handleFnKeyPress()
                        }
                    }
                } else {
                    if (isTrigger) {
                        return self.handleFnKeyPress()
                    }
                }
            }
            return false
        })
        
        shortcutCapture.$isRecord.sink { isRecord in
            if (isRecord) {
                self.clickMonitor.startGlobalMonitoring() {
                    self.clickMonitor.stopGlobalMonitoring()
                    self.shortcutCapture.stopRecord()
                }
            }
        }.store(in: &cancellables)
    }
    
    func arraysHaveSameElements<T: Comparable>(_ array1: [T], _ array2: [T]) -> Bool {
        return array1.sorted() == array2.sorted()
    }
    
    func handleFnKeyPress() -> Bool {
        InputSourceSwitcher.switchToNextInputSource()
        return shortcutCapture.isCanceling ? true : false
    }
    
}
