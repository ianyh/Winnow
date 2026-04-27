import Silica

nonisolated struct AppWindow: @unchecked Sendable {
    private let window: SIWindow?

    let title: String
    let applicationTitle: String?
    let windowID: UInt32?

    init(window: SIWindow, applicationTitle: String?) {
        self.window = window
        self.title = window.title() ?? ""
        self.applicationTitle = applicationTitle
        self.windowID = window.windowID()
    }
    
    init(title: String, applicationTitle: String?, windowID: UInt32?) {
        self.window = nil
        self.title = title
        self.applicationTitle = applicationTitle
        self.windowID = windowID
    }

    func focus() {
        window?.focus()
    }
}
