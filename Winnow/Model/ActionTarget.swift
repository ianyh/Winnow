import Foundation

/**
 An ActionTarget encapsulates a row that can be selected to perform a meaningful action.
 */
enum ActionTarget {
    /// The target is a window to be focused
    case focusAppWindow(window: AppWindow)
    /// The target is a slash command to be executed
    case runSlashCommand(command: SlashCommand)
    
    /// The title is a string displayed as the primary description of the action
    var title: String {
        switch self {
        case .focusAppWindow(let window):
            return window.title
        case .runSlashCommand(let command):
            return command.label
        }
    }
    
    /// The optional subtitle displayed as a caption of the action
    var subtitle: String? {
        switch self {
        case .focusAppWindow(let window):
            return window.applicationTitle
        case .runSlashCommand:
            return nil
        }
    }
    
    /// The `id` is used uniquely identify a target for inclusion and ordering
    var id: UInt32 {
        switch self {
        case .focusAppWindow(let window):
            return window.windowID ?? 0
        case .runSlashCommand(let command):
            return command.rawValue
        }
    }
}
