//
//  WinnowApp.swift
//  Winnow
//
//  Created by Ian Ynda-Hummel on 4/22/26.
//

import SwiftUI

@main
struct WinnowApp: App {
    init() {
        confirmAccessibilityPermissions()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 400, height: 400)
        .windowResizability(.contentSize)
        .windowLevel(.floating)
    }

    @discardableResult
    private func confirmAccessibilityPermissions() -> Bool {
        let options = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as String: true]
        return AXIsProcessTrustedWithOptions(options as CFDictionary)
    }
}
