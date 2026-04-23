import Observation
import Silica

@Observable
final class WindowStore {
    private(set) var windows: [Window] = []

    func load() {
        let visibleWindows = SIWindow.visibleWindows() ?? []
        windows = visibleWindows.map { Window(window: $0) }.filter { $0.title != nil && !$0.title!.isEmpty }
    }
}
