import Foundation
import CoreGraphics

class HelperMain {
    
    var eventTap: CFMachPort?
    
    func createEventTap() {
        let eventMask = CGEventMask(1 << CGEventType.keyDown.rawValue) | CGEventMask(1 << CGEventType.keyUp.rawValue) | CGEventMask(1 << CGEventType.flagsChanged.rawValue)

        
        eventTap = CGEvent.tapCreate(tap: .cghidEventTap,
                                     place: .headInsertEventTap,
                                     options: .defaultTap,
                                     eventsOfInterest: eventMask,
                                     callback: handleEvent,
                                     userInfo: nil)
        
        if let eventTap = eventTap {
            let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
            CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
            CGEvent.tapEnable(tap: eventTap, enable: true)
        } else {
            print("Failed to create event tap")
        }
    }
    
    func run() {
        createEventTap()
        CFRunLoopRun()
    }
}

func handleEvent(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
    if type == .keyDown || type == .keyUp {
        let keyCode = event.getIntegerValueField(.keyboardEventKeycode)
        print("Key code: \(keyCode)")
    } else if type == .flagsChanged {
        let flags = event.flags
        if flags.contains(.maskShift) {
            print("Shift key event detected!")
        }
        // Добавьте другие проверки для других модификаторов, если это необходимо
    }
    return Unmanaged.passRetained(event)
}

