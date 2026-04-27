import Observation
import Silica

@MainActor
@Observable
final class AppWindowStore {
    private static let ignoredBundleIDs = Set([
        "com.apple.dashboard",
        "com.apple.loginwindow",
        "com.apple.notificationcenterui",
        "com.apple.wifi.WiFiAgent",
        "com.apple.Spotlight",
        "com.apple.systemuiserver",
        "com.apple.dock",
        "com.apple.AirPlayUIAgent",
        "com.apple.dock.extra",
        "com.apple.PowerChime",
        "com.apple.WebKit.Networking",
        "com.apple.WebKit.WebContent",
        "com.apple.WebKit.GPU",
        "com.apple.FollowUpUI",
        "com.apple.controlcenter",
        "com.apple.SoftwareUpdateNotificationManager",
        "com.apple.TextInputMenuAgent",
        "com.apple.TextInputSwitcher",
        "com.apple.WindowManager",
        "com.apple.accessibility.AXVisualSupportAgent",
        "com.apple.talagent",
        "com.apple.wallpaper.agent",
        "com.apple.CharacterPaletteIM",
        "com.apple.LocalAuthentication.UIAgent",
        "com.apple.security.Keychain-Circle-Notification",
        "com.apple.backgroundtaskmanagement.agent",
        "com.apple.CoreLocationAgent",
        "com.apple.OSDUIHelper",
        "com.apple.ViewBridgeAuxiliary",
        "com.apple.transcriptBackgroundPoster.GradientExtension"
    ])

    private(set) var windows: [AppWindow] = []
    private let isPreview: Bool

    init() {
        self.isPreview = false
    }

    #if DEBUG
    init(previewWindows: [AppWindow]) {
        self.windows = previewWindows
        self.isPreview = true
    }
    #endif

    func load() async {
        guard !isPreview else { return }
        windows = await Task.detached(priority: .userInitiated) {
            let ignoredBundleIDs = await Self.ignoredBundleIDs
            let runningApplications = NSWorkspace.shared.runningApplications
            var applications: [SIApplication] = []
            for runningApplication in runningApplications {
                if let bundleIdentifier = runningApplication.bundleIdentifier, ignoredBundleIDs.contains(bundleIdentifier) {
                    continue
                }
                applications.append(SIApplication(runningApplication: runningApplication))
            }
            var appWindows: [AppWindow] = []
            for application in applications {
                let visibleWindows = application.visibleWindows()
                guard !visibleWindows.isEmpty else {
                    continue
                }
                let applicationTitle = application.title()
                let visibleAppWindows = visibleWindows
                    .map { AppWindow(window: $0, applicationTitle: applicationTitle) }
                    .filter { !$0.title.isEmpty }
                appWindows.append(contentsOf: visibleAppWindows)
            }
            return appWindows
        }.value
    }
}
