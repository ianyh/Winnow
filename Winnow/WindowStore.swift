import Observation
import Silica

@Observable
final class WindowStore {
    private(set) var windows: [SIWindow] = []

    func load() {
        windows = SIWindow.visibleWindows()?.filter { $0.title != nil && !$0.title!.isEmpty } ?? []
    }

    func focus(_ window: SIWindow) {
        window.focusWindow()
    }
}
