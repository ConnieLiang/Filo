import SwiftUI

/// iOS-specific extensions and configurations
/// Add iOS-specific code here that shouldn't be shared with macOS

extension View {
    /// iOS-specific view modifier for haptic feedback
    func iOSHapticFeedback(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) -> some View {
        self.onTapGesture {
            let impactFeedback = UIImpactFeedbackGenerator(style: style)
            impactFeedback.impactOccurred()
        }
    }
}

/// iOS-specific scene delegate handling if needed
class iOSSceneDelegate: NSObject, UIWindowSceneDelegate {
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // iOS-specific scene setup
    }
}
