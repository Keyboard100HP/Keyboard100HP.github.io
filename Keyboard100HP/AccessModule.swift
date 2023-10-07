import ApplicationServices

func hasAccessibilityPermissions() -> Bool {
    let checkOptionPrompt = kAXTrustedCheckOptionPrompt.takeUnretainedValue() as NSString
    let options = [checkOptionPrompt: false]
    let accessEnabled = AXIsProcessTrustedWithOptions(options as CFDictionary?)

    return accessEnabled
}

func requestAccessibilityPermissions() {
    let checkOptionPrompt = kAXTrustedCheckOptionPrompt.takeUnretainedValue() as NSString
    let options = [checkOptionPrompt: true]
    let _ = AXIsProcessTrustedWithOptions(options as CFDictionary?)
}
