import SwiftUI

@main
struct WinnowApp: App {
    init() {
        confirmAccessibilityPermissions()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .containerBackground(.thinMaterial, for: .window)
                .toolbarVisibility(.hidden, for: .windowToolbar)
                .ignoresSafeArea()
        }
        .windowStyle(.hiddenTitleBar)
        .windowLevel(.floating)
        .windowResizability(.contentSize)
        .restorationBehavior(.disabled)
        .defaultWindowPlacement { content, context in
            let size = content.sizeThatFits(.unspecified)
            let originX = context.defaultDisplay.bounds.midX - (size.width / 2.0)
            let originY = context.defaultDisplay.bounds.midY - (size.height / 2.0)
            let position = CGPoint(x: originX.rounded(), y: originY.rounded())
            return WindowPlacement(position, size: size)
        }

        Settings {
            SettingsView()
        }
    }

    @discardableResult
    private func confirmAccessibilityPermissions() -> Bool {
        let options = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as String: true]
        return AXIsProcessTrustedWithOptions(options as CFDictionary)
    }
}
