import Silica

nonisolated struct AppWindow: @unchecked Sendable {
    private let window: SIWindow
    
    let title: String
    let windowID: UInt32?

    init(window: SIWindow) {
        self.window = window
        self.title = window.title() ?? ""
        self.windowID = window.windowID()
    }

    func focus() {
        window.focus()
    }
}
