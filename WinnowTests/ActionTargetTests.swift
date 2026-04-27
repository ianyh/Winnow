import Testing
@testable import Winnow

struct ActionTargetTests {
    @Test func slashCommandTitleIsCommandLabel() {
        #expect(ActionTarget.runSlashCommand(command: .exit).title == "Quit Winnow")
        #expect(ActionTarget.runSlashCommand(command: .hide).title == "Hide Winnow")
        #expect(ActionTarget.runSlashCommand(command: .settings).title == "Open settings")
        #expect(ActionTarget.runSlashCommand(command: .reload).title == "Reload windows")
    }

    @Test func slashCommandHasNoSubtitle() {
        for command in SlashCommand.allCases {
            #expect(ActionTarget.runSlashCommand(command: command).subtitle == nil)
        }
    }

    @Test func slashCommandIDMatchesRawValue() {
        for command in SlashCommand.allCases {
            #expect(ActionTarget.runSlashCommand(command: command).id == command.rawValue)
        }
    }

    @Test func focusAppWindowExposesWindowMetadata() {
        let window = AppWindow(title: "Apple Developer", applicationTitle: "Safari", windowID: 42)
        let target = ActionTarget.focusAppWindow(window: window)

        #expect(target.title == "Apple Developer")
        #expect(target.subtitle == "Safari")
        #expect(target.id == 42)
    }

    @Test func focusAppWindowHandlesMissingFields() {
        let window = AppWindow(title: "Untitled", applicationTitle: nil, windowID: nil)
        let target = ActionTarget.focusAppWindow(window: window)

        #expect(target.title == "Untitled")
        #expect(target.subtitle == nil)
        #expect(target.id == 0)
    }
}
