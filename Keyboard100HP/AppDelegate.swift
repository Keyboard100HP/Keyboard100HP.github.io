//import Cocoa
//import IOKit.hid
//
//@NSApplicationMain
//class AppDelegate: NSObject, NSApplicationDelegate {
//
//    var manager: IOHIDManager?
//    
//    func applicationDidFinishLaunching(_ aNotification: Notification) {
//        manager = IOHIDManagerCreate(kCFAllocatorDefault, IOOptionBits(kIOHIDOptionsTypeNone))
//        IOHIDManagerSetDeviceMatching(manager, nil)
//        IOHIDManagerScheduleWithRunLoop(manager, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)
//        IOHIDManagerOpen(manager, IOOptionBits(kIOHIDOptionsTypeNone))
//        
//        IOHIDManagerRegisterInputValueCallback(manager, { context, result, sender, value in
//            let element = IOHIDValueGetElement(value)
//            if IOHIDElementGetType(element) == kIOHIDElementTypeInput_Button && IOHIDValueGetIntegerValue(value) > 0 {
//                print("Key pressed!")
//            }
//        }, nil)
//    }
//
//    func applicationWillTerminate(_ aNotification: Notification) {
//        IOHIDManagerClose(manager, IOOptionBits(kIOHIDOptionsTypeNone))
//    }
//}
