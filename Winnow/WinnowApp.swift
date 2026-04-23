//
//  WinnowApp.swift
//  Winnow
//
//  Created by Ian Ynda-Hummel on 4/22/26.
//

import SwiftUI

@main
struct WinnowApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 500, height: 400)
        .windowResizability(.contentSize)
    }
}
