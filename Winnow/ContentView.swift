import Silica
import SwiftUI

struct ContentView: View {
    @State private var store = WindowStore()
    @State private var query = ""
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

            Divider()

            List(filtered, id: \.windowID) { window in
                Button(window.title ?? "") {
                    window.focus()
                }
                .buttonStyle(.plain)
                .padding(.vertical, 4)
            }
            .listStyle(.plain)
        }
        .frame(width: 400, height: 400)
        .onAppear {
            store.load()
            searchFocused = true
        }
    }
}
