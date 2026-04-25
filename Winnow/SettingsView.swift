import SwiftUI

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
        }
        .formStyle(.grouped)
    }
}
