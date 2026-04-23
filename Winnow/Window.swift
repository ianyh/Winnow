import Silica

struct Window {
    private let window: SIWindow
    
    init(window: SIWindow) {
        self.window = window
    }
    
    var title: String? { window.title() }
    var windowID: UInt32 { window.windowID() }

    func focus() {
        window.focus()
    }
}
