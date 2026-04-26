import KeyboardShortcuts
import SwiftUI

extension KeyboardShortcuts.Name {
    static let launch = Self("launch", default: .init(.space, modifiers: [.control, .option, .command]))
}

struct SettingsView: View {
    var body: some View {
        TabView {
            GeneralSettingsView()
                .tabItem { Label("General", systemImage: "gearshape") }
        }
        .frame(width: 450, height: 250)
    }
}

private struct GeneralSettingsView: View {
    var body: some View {
        Form {
            KeyboardShortcuts.Recorder("Launch:", name: .launch)
        }
        .formStyle(.grouped)
    }
}
