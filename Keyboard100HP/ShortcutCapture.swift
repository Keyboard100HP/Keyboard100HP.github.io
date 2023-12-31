import Cocoa
import Foundation
import ServiceManagement

class ShortcutCapture: ObservableObject {
    static let shared = ShortcutCapture()
    
    let defaults = UserDefaults.standard
    
    var helperMonitor: HelperMonitor?
    var handle: ((_ keyData: (String, UInt16, String)) -> Bool)?
    
    @Published var eventData: (String, UInt16, String) = ("", 0, "")
    @Published var activeShortcutNames: [String] = []
    @Published var activeShortcutCodes: [UInt16] = []
    @Published var presedShortcutNames: [String] = []
    @Published var presedShortcutCodes: [UInt16] = []
    @Published var isMonitoring: Bool = false
    @Published var isCanceling: Bool = true
    @Published var isRecord: Bool = false
    
    init() {
        if let activeShortcutNamesStore = defaults.array(forKey: "activeShortcutNames") as? [String] {
            activeShortcutNames = activeShortcutNamesStore
        }
        if let isMonitoringStore = defaults.bool(forKey: "isMonitoring") as? Bool {
            if (isMonitoringStore) {
                startMonitoring()
            }
        }
        if let isCancelingStore = defaults.bool(forKey: "isCanceling") as? Bool {
            isCanceling = isCancelingStore
        }
        
        subscribeMonitoring()
    }
    
//    func isHelperInstalled() -> Bool {
//        let jobDicts = SMJobCopyDictionary(kSMDomainSystemLaunchd, "room.KeyReaderHelper" as CFString)
//        let installed = (jobDicts != nil)
//        return installed
//    }
    
//    func launchHelper() {
//        var authRef: AuthorizationRef?
//        let status = AuthorizationCreate(nil, nil, [], &authRef)
//        if status == errAuthorizationSuccess {
//            var error: Unmanaged<CFError>?
//            
//            if SMJobBless(kSMDomainSystemLaunchd, "room.KeyReaderHelper" as CFString, authRef, &error) {
//                print("Helper launched successfully")
//            } else {
//                if let error = error?.takeRetainedValue() {
//                    print("Error launching helper: \(error)")
//                }
//            }
//        }
//    }
    
    func subscribeMonitoring() {

        
        helperMonitor = HelperMonitor() { [unowned self] (keyData: (String, UInt16, String)) in
            self.eventData = keyData

            var isDownEvent = keyData.2 == "keyDown"
            var isUpEvent = keyData.2 == "keyUp"
            let isFlagsEvent = keyData.2 == "flagsChanged"

            let activeKeyName = keyData.0
            let activeKeyCode = keyData.1

            if (isFlagsEvent) {
                let isFlagDown = presedShortcutNames.contains(activeKeyName)

                if (isFlagDown) {
                    isUpEvent = true
                } else {
                    isDownEvent = true
                }
            }

            if (isDownEvent) {
                if (presedShortcutNames.isEmpty && !activeShortcutNames.isEmpty) {
                    if (isRecord) {
                        activeShortcutNames.removeAll()
                        activeShortcutCodes.removeAll()
                        defaults.set(activeShortcutNames, forKey: "activeShortcutNames")
                    }
                }
                if (!activeShortcutNames.contains(activeKeyName)) {
                    if (isRecord) {
                        activeShortcutNames.append(activeKeyName)
                        activeShortcutCodes.append(activeKeyCode)
                        defaults.set(activeShortcutNames, forKey: "activeShortcutNames")
                    }
                }
                if (!presedShortcutNames.contains(activeKeyName)) {
                    presedShortcutNames.append(activeKeyName)
                    presedShortcutCodes.append(activeKeyCode)
                }
            }

            if (isUpEvent) {
                presedShortcutNames = presedShortcutNames.filter { $0 != activeKeyName }
                presedShortcutCodes = presedShortcutCodes.filter { $0 != activeKeyCode }
            }

            if (isUpEvent && presedShortcutNames.isEmpty && !activeShortcutNames.isEmpty) {
                self.stopRecord()
            }

            let pressResult = self.handle!( (activeKeyName, activeKeyCode, (isDownEvent ? "keyDown" : "keyUp")) )
            
            if (isRecord) {
                return true
            } else {
                return pressResult
            }
        }
    }
    
    func presedClear() {
        if (!presedShortcutNames.isEmpty) {
            presedShortcutNames.removeAll()
            presedShortcutCodes.removeAll()
        }
    }
    
    func bindHandler(handle: @escaping (_ keyData: (String, UInt16, String)) -> Bool) {
        self.handle = handle
    }
    
    func startListening() {
        helperMonitor?.start()
    }
    
    func stopListening() {
        helperMonitor?.stop()
    }
    
    func startMonitoring() {
        isMonitoring = true
        defaults.set(isMonitoring, forKey: "isMonitoring")
        DispatchQueue.main.async {
            self.startListening()
        }
    }

    func stopMonitoring() {
        isMonitoring = false
        defaults.set(isMonitoring, forKey: "isMonitoring")
        DispatchQueue.main.async {
            self.stopListening()
        }
    }
    
    func startCanceling() {
        isCanceling = true
        defaults.set(isCanceling, forKey: "isCanceling")
    }

    func stopCanceling() {
        isCanceling = false
        defaults.set(isCanceling, forKey: "isCanceling")
    }
    
    func toggleCanceling() {
        isCanceling = !isCanceling
        defaults.set(isCanceling, forKey: "isCanceling")
    }
    
    var isCancelingToggler: Bool {
        get {
            return self.isCanceling
        }
        set {
            toggleCanceling()
        }
    }

    
    func startRecord() {
        isRecord = true
    }
    
    func stopRecord() {
        isRecord = false
    }

}
