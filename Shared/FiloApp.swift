import SwiftUI

@main
struct FiloApp: App {
    var body: some Scene {
        WindowGroup {
            #if os(iOS)
            SignInView()
            #else
            ContentView()
            #endif
        }
        #if os(macOS)
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 800, height: 600)
        #endif
    }
}
