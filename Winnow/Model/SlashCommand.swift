import Foundation

enum SlashCommand: UInt32, CaseIterable, Identifiable {
    case exit
    case hide
    case settings
    case reload

    var id: String {
        switch self {
        case .exit:
            "exit"
        case .hide:
            "hide"
        case .settings:
            "settings"
        case .reload:
            "reload"
        }
    }

    var trigger: String { "/" + id }

    var label: String {
        switch self {
        case .exit:
            return "Quit Winnow"
        case .hide:
            return "Hide Winnow"
        case .settings:
            return "Open settings"
        case .reload:
            return "Reload windows"
        }
    }

    static func matching(_ query: String) -> [SlashCommand] {
        let lowered = query.lowercased()
        return allCases.filter { $0.trigger.lowercased().hasPrefix(lowered) }
    }
}
