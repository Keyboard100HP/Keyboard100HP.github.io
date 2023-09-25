import Foundation
import IOKit.hid

class HelperMain {
    
    var manager: IOHIDManager
    
    init() {
        manager = IOHIDManagerCreate(kCFAllocatorDefault, IOOptionBits(kIOHIDOptionsTypeNone))
    }
    
    func openDevice() {
        let deviceMatching = [kIOHIDDeviceUsagePageKey: kHIDPage_GenericDesktop,
                              kIOHIDDeviceUsageKey: kHIDUsage_GD_Keyboard] as CFDictionary
        
        IOHIDManagerSetDeviceMatching(manager, deviceMatching)
        IOHIDManagerRegisterInputValueCallback(manager, handleKeyboard, nil)
        IOHIDManagerScheduleWithRunLoop(manager, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)
        IOHIDManagerOpen(manager, IOOptionBits(kIOHIDOptionsTypeNone))
    }
    
    func run() {
        openDevice()
        CFRunLoopRun()
    }
}

func handleKeyboard(context: Optional<UnsafeMutableRawPointer>, result: IOReturn, sender: Optional<UnsafeMutableRawPointer>, value: IOHIDValue) {
    let element = IOHIDValueGetElement(value)
    let usagePage = IOHIDElementGetUsagePage(element)
    let usage = IOHIDElementGetUsage(element)
    
    if usagePage == kHIDPage_KeyboardOrKeypad {
        print("Key Pressed: \(usage)")
    }
}


