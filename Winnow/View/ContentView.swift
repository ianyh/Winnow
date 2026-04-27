import AppKit
import Silica
import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.openSettings) private var openSettings
    @State private var store: AppWindowStore
    @State private var query = ""
    @State private var selectedIndex = 0
    @FocusState private var searchFocused: Bool

    init(store: AppWindowStore? = nil) {
        _store = State(initialValue: store ?? AppWindowStore())
    }

    private var filteredTargets: [ActionTarget] {
        if query.starts(with: "/") {
            return SlashCommand.matching(query).map { .runSlashCommand(command: $0) }
        } else {
            let windows = query.isEmpty ? store.windows : store.windows.filter {
                $0.title.localizedCaseInsensitiveContains(query)
            }
            return windows.map { .focusAppWindow(window: $0) }
        }
    }

    private var activeCount: Int {
        return filteredTargets.count
    }

    var body: some View {
        VStack(spacing: 0) {
            TextField("Search windows...", text: $query)
                .textFieldStyle(.plain)
                .font(.title)
                .padding()
                .focused($searchFocused)
                .onKeyPress(.downArrow) {
                    if activeCount > 0 {
                        selectedIndex = min(selectedIndex + 1, activeCount - 1)
                    }
                    return .handled
                }
                .onKeyPress(.upArrow) {
                    selectedIndex = max(selectedIndex - 1, 0)
                    return .handled
                }
                .onKeyPress(.return) {
                    if filteredTargets.indices.contains(selectedIndex) {
                        performAction(target: filteredTargets[selectedIndex])
                    }
                    return .handled
                }
                .onKeyPress(.escape) {
                    NSApp.hide(nil)
                    return .handled
                }

            Divider()
                .opacity(0.6)

            ScrollViewReader { proxy in
                List(Array(filteredTargets.enumerated()), id: \.element.id) { index, target in
                    Button {
                        performAction(target: target)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(target.title)
                                .font(.title3)
                                .frame(alignment: .leading)

                            if let subtitle = target.subtitle {
                                Text(subtitle)
                                    .font(.caption)
                                    .frame(alignment: .leading)
                            }
                        }.frame(maxWidth: .infinity, maxHeight: 100.0, alignment: .leading)
                    }
                    .buttonStyle(.plain)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 4)
                    .listRowSeparator(.hidden)
                    .listRowBackground(
                        index == selectedIndex
                            ? Color.accentColor.opacity(0.25)
                            : Color.clear
                    )
                    .containerBackground(.thinMaterial, for: .window)
                    .id(target.id)
                }
                .scrollContentBackground(.hidden)
                .listStyle(.plain)
                .onChange(of: selectedIndex) { _, new in
                    if filteredTargets.indices.contains(new) {
                        proxy.scrollTo(filteredTargets[new].id, anchor: .center)
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
    
    private func performAction(target: ActionTarget) {
        switch target {
        case .runSlashCommand(let command):
            runSlashCommand(command)
            if command != .reload {
                query = ""
                selectedIndex = 0
            }
        case .focusAppWindow(let window):
            window.focus()
        }
    }
    
    private func runSlashCommand(_ command: SlashCommand) {
        switch command {
        case .exit:
            NSApp.terminate(nil)
        case .hide:
            NSApp.hide(nil)
        case .settings:
            NSApp.unhide(nil)
            NSRunningApplication.current.activate(options: [.activateAllWindows])
            openSettings()
        case .reload:
            Task { @MainActor in await store.load() }
        }
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
        AppWindow(title: "Apple Developer", applicationTitle: "Safari", windowID: 1),
        AppWindow(title: "Winnow", applicationTitle: "Xcode", windowID: 2),
        AppWindow(title: "winnow", applicationTitle: "Terminal", windowID: 3),
        AppWindow(title: "engineering", applicationTitle: "Slack", windowID: 4),
        AppWindow(title: "Window Manager Plans", applicationTitle: nil, windowID: 5),
    ]))
}

#Preview("Empty") {
    ContentView(store: AppWindowStore(previewWindows: []))
}
#endif
