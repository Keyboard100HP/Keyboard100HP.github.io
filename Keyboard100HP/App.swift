import SwiftUI
import Combine
import AppKit

@main
struct Keyboard100HP: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        MenuBarExtra("Keyboard100HP", systemImage: "command") {
            ContentView()
        }
        .menuBarExtraStyle(.window)
    }
}
