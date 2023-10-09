import CoreGraphics
import Foundation

class HelperMonitor {
    var checkTapTimer: Timer?
    var eventTap: CFMachPort?
    var handler: ((String, UInt16, String)) -> Bool
    
    init(handler: @escaping ((String, UInt16, String)) -> Bool) {
        self.handler = handler
        
        // Запросите разрешение или уведомьте пользователя о необходимости предоставить разрешение.
        requestAccessibilityPermissions()
    }
    
    deinit {
        stop()
    }
    
    @objc func checkTapStatus() {
        if ((eventTap) != nil) {
            if (!CGEvent.tapIsEnabled(tap: eventTap!)) {
                CGEvent.tapEnable(tap: eventTap!, enable: true)
            }
        } else {
            createEventTap()
        }
    }

    
    func createEventTap() {
        let eventMask = CGEventMask(1 << CGEventType.keyDown.rawValue) | CGEventMask(1 << CGEventType.keyUp.rawValue) | CGEventMask(1 << CGEventType.flagsChanged.rawValue)
        
        let userInfo = Unmanaged.passUnretained(self).toOpaque()
        
        eventTap = CGEvent.tapCreate(
            tap: .cghidEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: eventMask,
            callback: handleEvent,
            userInfo: userInfo
        )
        
        if let eventTap = eventTap {
            let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
            CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
            CGEvent.tapEnable(tap: eventTap, enable: true)
        } else {
            print("Failed to create event tap")
        }
    }
    
    public func start() {
        createEventTap()
        
        // Запускаем таймер, который будет проверять состояние tap каждые 2 секунд
        checkTapTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(checkTapStatus), userInfo: nil, repeats: true)
    }
    
    public func stop() {
        if let eventTap = eventTap {
            CGEvent.tapEnable(tap: eventTap, enable: false)
        }
        
        // Останавливаем таймер
         checkTapTimer?.invalidate()
         checkTapTimer = nil
    }

}

func handleEvent(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
    guard let refcon = refcon else { return Unmanaged.passRetained(event) }
    let monitor = Unmanaged<HelperMonitor>.fromOpaque(refcon).takeUnretainedValue()
    
    let keyName: String = keyCodeToName(keyCode: UInt16(event.getIntegerValueField(.keyboardEventKeycode)))
    let keyCode = UInt16(event.getIntegerValueField(.keyboardEventKeycode))
    var keyType = ""
    
    switch type {
    case .flagsChanged:
        keyType = "flagsChanged"
    case .keyDown:
        keyType = "keyDown"
    case .keyUp:
        keyType = "keyUp"
    default:
        break
    }
    
    var res = monitor.handler((keyName, keyCode, keyType))
    
    if res == true {
        return nil
    }

    return Unmanaged.passRetained(event)
}



func keyCodeToName(keyCode: UInt16) -> String {
    switch keyCode {
        case 0: return "A"
        case 1: return "S"
        case 2: return "D"
        case 3: return "F"
        case 4: return "H"
        case 5: return "G"
        case 6: return "Z"
        case 7: return "X"
        case 8: return "C"
        case 9: return "V"
        case 10: return "§" // это может изменяться в зависимости от раскладки
        case 11: return "B"
        case 12: return "Q"
        case 13: return "W"
        case 14: return "E"
        case 15: return "R"
        case 16: return "Y"
        case 17: return "T"
        case 18: return "1"
        case 19: return "2"
        case 20: return "3"
        case 21: return "4"
        case 22: return "6"
        case 23: return "5"
        case 24: return "="
        case 25: return "9"
        case 26: return "7"
        case 27: return "-"
        case 28: return "8"
        case 29: return "0"
        case 30: return "]"
        case 31: return "O"
        case 32: return "U"
        case 33: return "["
        case 34: return "I"
        case 35: return "P"
        case 36: return "Return"
        case 37: return "L"
        case 38: return "J"
        case 39: return "'"
        case 40: return "K"
        case 41: return ";"
        case 42: return "\\"
        case 43: return ","
        case 44: return "/"
        case 45: return "N"
        case 46: return "M"
        case 47: return "."
        case 48: return "Tab"
        case 49: return "Space"
        case 50: return "`"
        case 51: return "Delete"
        case 52: return "Enter"
        case 53: return "Escape"
        case 54: return "Command (Right)"
        case 55: return "Command (Left)"
        case 56: return "Shift (Left)"
        case 57: return "Caps Lock"
        case 58: return "Option (Left)"
        case 59: return "Control (Left)"
        case 60: return "Shift (Right)"
        case 61: return "Option (Right)"
        case 62: return "Control (Right)"
        case 63: return "Function"
        case 64: return "F17"
        case 65: return "Numpad ."
        case 67: return "Numpad *"
        case 69: return "Numpad +"
        case 71: return "Numpad Clear"
        case 75: return "Numpad /"
        case 76: return "Numpad Enter"
        case 78: return "Numpad -"
        case 79: return "F18"
        case 80: return "F19"
        case 81: return "Numpad ="
        case 82: return "Numpad 0"
        case 83: return "Numpad 1"
        case 84: return "Numpad 2"
        case 85: return "Numpad 3"
        case 86: return "Numpad 4"
        case 87: return "Numpad 5"
        case 88: return "Numpad 6"
        case 89: return "Numpad 7"
        case 91: return "Numpad 8"
        case 92: return "Numpad 9"
        case 93: return "Yen (depending on layout)"
        case 94: return "Underscore (depending on layout)"
        case 95: return "F20"
        case 96: return "F5"
        case 97: return "F6"
        case 98: return "F7"
        case 99: return "F3"
        case 100: return "F8"
        case 101: return "F9"
        case 103: return "F11"
        case 105: return "F13"
        case 107: return "F16"
        case 109: return "F14"
        case 111: return "F10"
        case 113: return "F12"
        case 114: return "F15"
        case 115: return "Help"
        case 116: return "Page Up"
        case 117: return "Forward Delete"
        case 118: return "F4"
        case 119: return "End"
        case 120: return "F2"
        case 121: return "Page Down"
        case 122: return "F1"
        case 123: return "Left Arrow"
        case 124: return "Right Arrow"
        case 125: return "Down Arrow"
        case 126: return "Up Arrow"
        default: return "Unknown"
    }
}
