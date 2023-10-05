//
//  Keyboard100HPApp.swift
//  Keyboard100HP
//
//  Created by Maksim on 25.09.2023.
//

import SwiftUI
import Combine
import AppKit

//final class Zoo: ObservableObject {
//    private var cancellable = Set<AnyCancellable>()
//
//    init() {
//        NotificationCenter.default.publisher(for: NSWindow.didBecomeKeyNotification)
//            .sink { _ in
//                print("✅")
//            }
//            .store(in: &cancellable)
//    }
//}

@main
struct LangKeeperApp: App {
//    @StateObject private var zoo = Zoo()
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        MenuBarExtra("Keyboard100HP", systemImage: "hammer") {
            ContentView()
        }
        .menuBarExtraStyle(.window)
    }
}
