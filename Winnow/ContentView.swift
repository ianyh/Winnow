import Silica
import SwiftUI

struct ContentView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var store = WindowStore()
    @State private var query = ""
    @State private var selectedIndex = 0
    @FocusState private var searchFocused: Bool

    var filtered: [Window] {
        guard !query.isEmpty else { return store.windows }
        return store.windows.filter {
            $0.title?.localizedCaseInsensitiveContains(query) == true
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

            Divider()

            ScrollViewReader { proxy in
                List(Array(filtered.enumerated()), id: \.element.windowID) { index, window in
                    Button {
                        focusWindow(window)
                    } label: {
                        Text(window.title ?? "")
                            .frame(maxWidth: .infinity, alignment: .leading)
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
        .frame(width: 400, height: 400)
        .onChange(of: query) { _, _ in
            selectedIndex = 0
        }
        .onAppear {
            store.load()
            searchFocused = true
        }
    }
    
    private func focusWindow(_ window: Window) {
        window.focus()
        dismiss()
    }
}
