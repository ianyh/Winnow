import Testing
@testable import Winnow

struct SlashCommandTests {
    @Test func triggerIsSlashPrefixedID() {
        for command in SlashCommand.allCases {
            #expect(command.trigger == "/" + command.id)
        }
    }

    @Test func idMatchesExpectedString() {
        #expect(SlashCommand.exit.id == "exit")
        #expect(SlashCommand.hide.id == "hide")
        #expect(SlashCommand.settings.id == "settings")
        #expect(SlashCommand.reload.id == "reload")
    }

    @Test func matchingSlashReturnsAllCommands() {
        #expect(SlashCommand.matching("/") == SlashCommand.allCases)
    }

    @Test func matchingNarrowsByPrefix() {
        #expect(SlashCommand.matching("/ex") == [.exit])
        #expect(SlashCommand.matching("/hi") == [.hide])
        #expect(SlashCommand.matching("/se") == [.settings])
        #expect(SlashCommand.matching("/re") == [.reload])
    }

    @Test func matchingFullTriggerReturnsExactCommand() {
        #expect(SlashCommand.matching("/exit") == [.exit])
    }

    @Test func matchingIsCaseInsensitive() {
        #expect(SlashCommand.matching("/EXIT") == [.exit])
        #expect(SlashCommand.matching("/Set") == [.settings])
    }

    @Test func matchingUnknownPrefixReturnsEmpty() {
        #expect(SlashCommand.matching("/zzz").isEmpty)
        #expect(SlashCommand.matching("/exitnow").isEmpty)
    }
}
