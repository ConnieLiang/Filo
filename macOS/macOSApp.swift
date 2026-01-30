import SwiftUI
import AppKit

/// macOS-specific extensions and configurations
/// Add macOS-specific code here that shouldn't be shared with iOS

extension View {
    /// macOS-specific view modifier for window styling
    func macOSWindowStyle() -> some View {
        self
            .frame(minWidth: 400, minHeight: 300)
    }
}

/// macOS-specific app delegate for additional functionality
class macOSAppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        // macOS-specific setup
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

/// macOS Menu Bar commands
struct MacOSCommands: Commands {
    var body: some Commands {
        CommandGroup(after: .appInfo) {
            Button("Check for Updates...") {
                // Add update check logic
            }
        }
        
        CommandMenu("Tools") {
            Button("Preferences...") {
                // Open preferences
            }
            .keyboardShortcut(",", modifiers: .command)
        }
    }
}
