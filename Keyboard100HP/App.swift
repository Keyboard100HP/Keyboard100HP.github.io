//
//  Keyboard100HPApp.swift
//  Keyboard100HP
//
//  Created by Maksim on 25.09.2023.
//

import SwiftUI

@main
struct Keyboard100HPApp: App {
    let monitoring = Monitoring()

    init(){
        monitoring.run()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
