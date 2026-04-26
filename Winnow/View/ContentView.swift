import AppKit
import Silica
import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    @State private var store: AppWindowStore
    @State private var query = ""
    @State private var selectedIndex = 0
    @FocusState private var searchFocused: Bool

    init(store: AppWindowStore? = nil) {
        _store = State(initialValue: store ?? AppWindowStore())
    }

    var filtered: [AppWindow] {
        guard !query.isEmpty else { return store.windows }
        return store.windows.filter {
            $0.title.localizedCaseInsensitiveContains(query) == true
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            TextField("Search windows...", text: $query)
                .textFieldStyle(.plain)
                .font(.title2)
                .padding()
                .focused($searchFocused)
                .onKeyPress(.downArrow) {
                    if !filtered.isEmpty {
                        selectedIndex = min(selectedIndex + 1, filtered.count - 1)
                    }
                    return .handled
                }
                .onKeyPress(.upArrow) {
                    selectedIndex = max(selectedIndex - 1, 0)
                    return .handled
                }
                .onKeyPress(.return) {
                    if filtered.indices.contains(selectedIndex) {
                        focusWindow(filtered[selectedIndex])
                    }
                    return .handled
                }
                .onKeyPress(.escape) {
                    NSApp.hide(nil)
                    return .handled
                }

            Divider()

            ScrollViewReader { proxy in
                List(Array(filtered.enumerated()), id: \.element.windowID) { index, window in
                    Button {
                        focusWindow(window)
                    } label: {
                        Text(window.title)
                            .frame(maxWidth: .infinity, maxHeight: 500, alignment: .leading)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .padding(.vertical, 4)
                    .listRowBackground(
                        index == selectedIndex
                            ? Color.accentColor.opacity(0.25)
                            : Color.clear
                    )
                    .id(window.windowID)
                }
                .scrollContentBackground(.hidden)
                .listStyle(.plain)
                .onChange(of: selectedIndex) { _, new in
                    if filtered.indices.contains(new) {
                        proxy.scrollTo(filtered[new].windowID, anchor: .center)
                    }
                }
            }
            .scrollContentBackground(.hidden)
        }
        .frame(width: 500, height: 500)
        .onChange(of: query) { _, _ in
            selectedIndex = 0
        }
        .onAppear {
            reset()
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active { reset() }
        }
    }

    private func focusWindow(_ window: AppWindow) {
        window.focus()
        NSApp.hide(nil)
    }

    private func reset() {
        query = ""
        selectedIndex = 0
        searchFocused = false
        Task { @MainActor in
            searchFocused = true
            await store.load()
        }
    }
}

#if DEBUG
#Preview("Populated") {
    ContentView(store: AppWindowStore(previewWindows: [
        AppWindow(title: "Safari — Apple Developer", windowID: 1),
        AppWindow(title: "Xcode — Winnow", windowID: 2),
        AppWindow(title: "Terminal — winnow", windowID: 3),
        AppWindow(title: "Slack — engineering", windowID: 4),
        AppWindow(title: "Notes — Window Manager Plans", windowID: 5),
    ]))
}

#Preview("Empty") {
    ContentView(store: AppWindowStore(previewWindows: []))
}
#endif
