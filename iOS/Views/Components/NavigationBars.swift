//
//  NavigationBars.swift
//  Filo
//
//  iOS 26 Liquid Glass navigation bars following Apple HIG
//  with Filo's color palette for tinted elements
//

import SwiftUI

// MARK: - Filo Color Palette

extension Color {
    /// Filo's primary brand color - used for tinted glass elements
    static let filoPrimary = Color(hex: "#22A0FB")
    
    /// Filo's secondary tint
    static let filoSecondary = Color(hex: "#1F9EFA")
}

// MARK: - HIG Constants

private enum HIG {
    /// Apple HIG minimum touch target size (44pt)
    static let minTouchTarget: CGFloat = 44
    
    /// Standard icon button size for navigation
    static let iconButtonSize: CGFloat = 44
    
    /// Icon size within buttons
    static let iconSize: CGFloat = 20
    
    /// Navigation bar height
    static let navBarHeight: CGFloat = 52
    
    /// Horizontal padding for navigation bars
    static let horizontalPadding: CGFloat = 20
    
    /// Spacing between grouped actions
    static let actionSpacing: CGFloat = 16
    
    /// Spacing within action pills
    static let pillSpacing: CGFloat = 20
}

// MARK: - iOS 26 Glass Button

/// A glass-effect icon button following Apple HIG touch targets
@available(iOS 26.0, *)
struct FiloGlassIconButton: View {
    let icon: String
    let action: () -> Void
    var tint: Color? = nil
    var accessibilityLabel: String? = nil
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: HIG.iconSize, weight: .medium))
                .frame(width: HIG.iconButtonSize, height: HIG.iconButtonSize)
        }
        .buttonStyle(.glass)
        .buttonBorderShape(.circle)
        .tint(tint)
        .accessibilityLabel(accessibilityLabel ?? icon)
    }
}

/// Fallback glass button for iOS 15-25
struct FiloGlassIconButtonLegacy: View {
    let icon: String
    let action: () -> Void
    var tint: Color? = nil
    var accessibilityLabel: String? = nil
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: HIG.iconSize, weight: .medium))
                .foregroundStyle(tint ?? .primary)
                .frame(width: HIG.iconButtonSize, height: HIG.iconButtonSize)
                .background(
                    ZStack {
                        Circle()
                            .fill(.ultraThinMaterial)
                        
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.6),
                                        Color.white.opacity(0.2)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .blendMode(.overlay)
                        
                        Circle()
                            .strokeBorder(Color.white.opacity(0.3), lineWidth: 0.5)
                    }
                )
                .clipShape(Circle())
                .scaleEffect(isPressed ? 0.92 : 1.0)
                .animation(.spring(response: 0.2, dampingFraction: 0.6), value: isPressed)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
        .accessibilityLabel(accessibilityLabel ?? icon)
    }
}

// MARK: - iOS 26 Send Button

/// Blue send button with Filo's primary color
@available(iOS 26.0, *)
struct FiloSendButton: View {
    let action: () -> Void
    var size: CGFloat = 28
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "arrow.up")
                .font(.system(size: size * 0.5, weight: .semibold))
                .frame(width: size, height: size)
        }
        .buttonStyle(.glassProminent)
        .buttonBorderShape(.circle)
        .tint(.filoPrimary)
        .clipShape(Circle()) // Workaround for glassProminent circle artifacts
        .accessibilityLabel("Send")
    }
}

/// Legacy send button for iOS 15-25
struct FiloSendButtonLegacy: View {
    let action: () -> Void
    var size: CGFloat = 28
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(Color.filoPrimary)
                    .frame(width: size, height: size)
                
                Image(systemName: "arrow.up")
                    .font(.system(size: size * 0.5, weight: .semibold))
                    .foregroundColor(.white)
            }
            .scaleEffect(isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: isPressed)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
        .accessibilityLabel("Send")
    }
}

// MARK: - iOS 26 Read Email Navigation

@available(iOS 26.0, *)
struct ReadEmailNavigation: View {
    var onBack: () -> Void
    var onArchive: () -> Void = {}
    var onShare: () -> Void = {}
    var onTag: () -> Void = {}
    var onMore: () -> Void = {}
    
    var body: some View {
        GlassEffectContainer(spacing: 12) {
            HStack {
                // Back button
                FiloGlassIconButton(
                    icon: "chevron.left",
                    action: onBack,
                    accessibilityLabel: "Back"
                )
                
                Spacer()
                
                // Action bar - grouped glass pill
                HStack(spacing: HIG.pillSpacing) {
                    Button(action: onArchive) {
                        Image(systemName: "archivebox")
                            .font(.system(size: HIG.iconSize, weight: .medium))
                    }
                    .accessibilityLabel("Archive")
                    
                    Button(action: onShare) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: HIG.iconSize, weight: .medium))
                    }
                    .accessibilityLabel("Share")
                    
                    Button(action: onTag) {
                        Image(systemName: "tag")
                            .font(.system(size: HIG.iconSize, weight: .medium))
                    }
                    .accessibilityLabel("Add label")
                }
                .frame(height: HIG.iconButtonSize)
                .padding(.horizontal, 16)
                .glassEffect(.regular.interactive(), in: Capsule())
                
                // More button
                FiloGlassIconButton(
                    icon: "ellipsis",
                    action: onMore,
                    accessibilityLabel: "More options"
                )
            }
            .padding(.horizontal, HIG.horizontalPadding)
            .frame(height: HIG.navBarHeight)
        }
    }
}

// MARK: - iOS 26 Select Email Navigation

@available(iOS 26.0, *)
struct SelectEmailNavigation: View {
    var selectedCount: Int
    var onBack: () -> Void
    var onArchive: () -> Void = {}
    var onShare: () -> Void = {}
    var onTag: () -> Void = {}
    var onMail: () -> Void = {}
    var onMore: () -> Void = {}
    
    var body: some View {
        GlassEffectContainer(spacing: 12) {
            HStack {
                // Back button with selection count
                HStack(spacing: 6) {
                    FiloGlassIconButton(
                        icon: "chevron.left",
                        action: onBack,
                        accessibilityLabel: "Cancel selection"
                    )
                    
                    Text("\(selectedCount)")
                        .font(.system(size: 15, weight: .medium))
                        .tracking(-0.2)
                        .foregroundStyle(.primary)
                        .accessibilityLabel("\(selectedCount) selected")
                }
                
                Spacer()
                
                // Action bar with more icons
                HStack(spacing: HIG.pillSpacing) {
                    Button(action: onArchive) {
                        Image(systemName: "archivebox")
                            .font(.system(size: HIG.iconSize, weight: .medium))
                    }
                    .accessibilityLabel("Archive")
                    
                    Button(action: onShare) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: HIG.iconSize, weight: .medium))
                    }
                    .accessibilityLabel("Share")
                    
                    Button(action: onTag) {
                        Image(systemName: "tag")
                            .font(.system(size: HIG.iconSize, weight: .medium))
                    }
                    .accessibilityLabel("Add label")
                    
                    Button(action: onMail) {
                        Image(systemName: "envelope")
                            .font(.system(size: HIG.iconSize, weight: .medium))
                    }
                    .accessibilityLabel("Mark as unread")
                }
                .frame(height: HIG.iconButtonSize)
                .padding(.horizontal, 16)
                .glassEffect(.regular.interactive(), in: Capsule())
                
                // More button
                FiloGlassIconButton(
                    icon: "ellipsis",
                    action: onMore,
                    accessibilityLabel: "More options"
                )
            }
            .padding(.horizontal, HIG.horizontalPadding)
            .frame(height: HIG.navBarHeight)
        }
    }
}

// MARK: - iOS 26 Compose Navigation

@available(iOS 26.0, *)
struct ComposeNavigation: View {
    var onClose: () -> Void
    var onAttach: () -> Void = {}
    var onSend: () -> Void
    var sendEnabled: Bool = true
    
    var body: some View {
        GlassEffectContainer(spacing: 12) {
            HStack {
                // Close button
                FiloGlassIconButton(
                    icon: "xmark",
                    action: onClose,
                    accessibilityLabel: "Close"
                )
                
                Spacer()
                
                // Action bar with attachment and send
                HStack(spacing: HIG.pillSpacing) {
                    Button(action: onAttach) {
                        Image(systemName: "paperclip")
                            .font(.system(size: HIG.iconSize, weight: .medium))
                    }
                    .accessibilityLabel("Attach file")
                    
                    FiloSendButton(action: onSend)
                        .opacity(sendEnabled ? 1.0 : 0.4)
                        .disabled(!sendEnabled)
                }
                .frame(height: HIG.iconButtonSize)
                .padding(.horizontal, 16)
                .glassEffect(.regular.interactive(), in: Capsule())
            }
            .padding(.horizontal, HIG.horizontalPadding)
            .frame(height: HIG.navBarHeight)
        }
    }
}

// MARK: - iOS 26 Subpage Navigation

@available(iOS 26.0, *)
struct SubpageNavigation: View {
    var title: String
    var onBack: () -> Void
    var trailing: (() -> AnyView)? = nil
    
    var body: some View {
        GlassEffectContainer {
            VStack(spacing: 0) {
                HStack(spacing: 16) {
                    // Back button
                    FiloGlassIconButton(
                        icon: "chevron.left",
                        action: onBack,
                        accessibilityLabel: "Back"
                    )
                    
                    // Title
                    Text(title)
                        .font(.system(size: 17, weight: .bold))
                        .tracking(-0.2)
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    // Trailing action or invisible spacer for balance
                    if let trailing = trailing {
                        trailing()
                    } else {
                        Color.clear
                            .frame(width: HIG.iconButtonSize, height: HIG.iconButtonSize)
                    }
                }
                .padding(.horizontal, HIG.horizontalPadding)
                .frame(height: HIG.navBarHeight)
                
                // Bottom border
                Rectangle()
                    .fill(Color.primary.opacity(0.05))
                    .frame(height: 1)
            }
        }
    }
}

// MARK: - Legacy Navigation Bars (iOS 15-25)

struct ReadEmailNavigationLegacy: View {
    var onBack: () -> Void
    var onArchive: () -> Void = {}
    var onShare: () -> Void = {}
    var onTag: () -> Void = {}
    var onMore: () -> Void = {}
    
    var body: some View {
        HStack {
            FiloGlassIconButtonLegacy(
                icon: "chevron.left",
                action: onBack,
                accessibilityLabel: "Back"
            )
            
            Spacer()
            
            // Legacy action pill
            HStack(spacing: HIG.pillSpacing) {
                Button(action: onArchive) {
                    Image(systemName: "archivebox")
                        .font(.system(size: HIG.iconSize, weight: .medium))
                        .foregroundStyle(.primary)
                }
                
                Button(action: onShare) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: HIG.iconSize, weight: .medium))
                        .foregroundStyle(.primary)
                }
                
                Button(action: onTag) {
                    Image(systemName: "tag")
                        .font(.system(size: HIG.iconSize, weight: .medium))
                        .foregroundStyle(.primary)
                }
            }
            .frame(height: HIG.iconButtonSize)
            .padding(.horizontal, 16)
            .background(
                Capsule()
                    .fill(.ultraThinMaterial)
                    .overlay(
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.6), Color.white.opacity(0.2)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .blendMode(.overlay)
                    )
                    .overlay(
                        Capsule()
                            .strokeBorder(Color.white.opacity(0.3), lineWidth: 0.5)
                    )
            )
            
            FiloGlassIconButtonLegacy(
                icon: "ellipsis",
                action: onMore,
                accessibilityLabel: "More options"
            )
        }
        .padding(.horizontal, HIG.horizontalPadding)
        .frame(height: HIG.navBarHeight)
    }
}

struct ComposeNavigationLegacy: View {
    var onClose: () -> Void
    var onAttach: () -> Void = {}
    var onSend: () -> Void
    var sendEnabled: Bool = true
    
    var body: some View {
        HStack {
            FiloGlassIconButtonLegacy(
                icon: "xmark",
                action: onClose,
                accessibilityLabel: "Close"
            )
            
            Spacer()
            
            HStack(spacing: HIG.pillSpacing) {
                Button(action: onAttach) {
                    Image(systemName: "paperclip")
                        .font(.system(size: HIG.iconSize, weight: .medium))
                        .foregroundStyle(.primary)
                }
                
                FiloSendButtonLegacy(action: onSend)
                    .opacity(sendEnabled ? 1.0 : 0.4)
                    .disabled(!sendEnabled)
            }
            .frame(height: HIG.iconButtonSize)
            .padding(.horizontal, 16)
            .background(
                Capsule()
                    .fill(.ultraThinMaterial)
                    .overlay(
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.6), Color.white.opacity(0.2)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .blendMode(.overlay)
                    )
                    .overlay(
                        Capsule()
                            .strokeBorder(Color.white.opacity(0.3), lineWidth: 0.5)
                    )
            )
        }
        .padding(.horizontal, HIG.horizontalPadding)
        .frame(height: HIG.navBarHeight)
    }
}

struct SubpageNavigationLegacy: View {
    var title: String
    var onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                FiloGlassIconButtonLegacy(
                    icon: "chevron.left",
                    action: onBack,
                    accessibilityLabel: "Back"
                )
                
                Text(title)
                    .font(.system(size: 17, weight: .bold))
                    .tracking(-0.2)
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Color.clear
                    .frame(width: HIG.iconButtonSize, height: HIG.iconButtonSize)
            }
            .padding(.horizontal, HIG.horizontalPadding)
            .frame(height: HIG.navBarHeight)
            
            Rectangle()
                .fill(Color.primary.opacity(0.05))
                .frame(height: 1)
        }
    }
}

// MARK: - Version-Adaptive Wrapper Views

/// Use these wrappers in your app - they automatically select iOS 26 or legacy implementation

struct FiloReadEmailNav: View {
    var onBack: () -> Void
    var onArchive: () -> Void = {}
    var onShare: () -> Void = {}
    var onTag: () -> Void = {}
    var onMore: () -> Void = {}
    
    var body: some View {
        if #available(iOS 26.0, *) {
            ReadEmailNavigation(
                onBack: onBack,
                onArchive: onArchive,
                onShare: onShare,
                onTag: onTag,
                onMore: onMore
            )
        } else {
            ReadEmailNavigationLegacy(
                onBack: onBack,
                onArchive: onArchive,
                onShare: onShare,
                onTag: onTag,
                onMore: onMore
            )
        }
    }
}

struct FiloComposeNav: View {
    var onClose: () -> Void
    var onAttach: () -> Void = {}
    var onSend: () -> Void
    var sendEnabled: Bool = true
    
    var body: some View {
        if #available(iOS 26.0, *) {
            ComposeNavigation(
                onClose: onClose,
                onAttach: onAttach,
                onSend: onSend,
                sendEnabled: sendEnabled
            )
        } else {
            ComposeNavigationLegacy(
                onClose: onClose,
                onAttach: onAttach,
                onSend: onSend,
                sendEnabled: sendEnabled
            )
        }
    }
}

struct FiloSubpageNav: View {
    var title: String
    var onBack: () -> Void
    
    var body: some View {
        if #available(iOS 26.0, *) {
            SubpageNavigation(title: title, onBack: onBack)
        } else {
            SubpageNavigationLegacy(title: title, onBack: onBack)
        }
    }
}

// MARK: - Color Extension (if not defined elsewhere)

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Previews

#if DEBUG
@available(iOS 26.0, *)
#Preview("Read Email (iOS 26)") {
    ZStack {
        LinearGradient(
            colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        
        VStack {
            ReadEmailNavigation(onBack: {})
            Spacer()
        }
    }
}

@available(iOS 26.0, *)
#Preview("Select Email (iOS 26)") {
    ZStack {
        Color(hex: "#F5F5F5").ignoresSafeArea()
        
        VStack {
            SelectEmailNavigation(selectedCount: 3, onBack: {})
            Spacer()
        }
    }
}

@available(iOS 26.0, *)
#Preview("Compose (iOS 26)") {
    ZStack {
        Color.white.ignoresSafeArea()
        
        VStack {
            ComposeNavigation(onClose: {}, onSend: {})
            Spacer()
        }
    }
}

@available(iOS 26.0, *)
#Preview("Subpage (iOS 26)") {
    ZStack {
        Color.white.ignoresSafeArea()
        
        VStack {
            SubpageNavigation(title: "Settings", onBack: {})
            Spacer()
        }
    }
}

#Preview("Read Email (Legacy)") {
    ZStack {
        Color(hex: "#F5F5F5").ignoresSafeArea()
        
        VStack {
            ReadEmailNavigationLegacy(onBack: {})
            Spacer()
        }
    }
}

#Preview("Compose (Legacy)") {
    ZStack {
        Color.white.ignoresSafeArea()
        
        VStack {
            ComposeNavigationLegacy(onClose: {}, onSend: {})
            Spacer()
        }
    }
}
#endif
