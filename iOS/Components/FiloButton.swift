import SwiftUI

// MARK: - Button Size
enum FiloButtonSize {
    case small
    case medium
    case large
    
    var paddingHorizontal: CGFloat {
        switch self {
        case .small: return 12
        case .medium: return 30
        case .large: return 34
        }
    }
    
    var paddingVertical: CGFloat {
        switch self {
        case .small: return 8
        case .medium: return 12
        case .large: return 16
        }
    }
    
    var fontSize: CGFloat { 15 }
    
    var fontWeight: Font.Weight {
        switch self {
        case .small, .medium: return .medium
        case .large: return .bold
        }
    }
    
    var iconSize: CGFloat {
        switch self {
        case .small: return 16
        case .medium: return 18
        case .large: return 20
        }
    }
    
    var width: CGFloat? {
        switch self {
        case .large: return 350
        default: return nil
        }
    }
}

// MARK: - Button Variant
enum FiloButtonVariant {
    case outlined
    case ghost
    case tinted
    case filled
    
    func backgroundColor(for colorScheme: ColorScheme) -> Color {
        switch self {
        case .outlined:
            return colorScheme == .dark ? Color(hex: "2A2A30") : .white
        case .ghost:
            return colorScheme == .dark ? Color.white.opacity(0.06) : Color.black.opacity(0.04)
        case .tinted:
            return colorScheme == .dark ? Color(hex: "4CB4FF").opacity(0.16) : Color(hex: "4CB4FF").opacity(0.12)
        case .filled:
            return colorScheme == .dark ? Color(hex: "45B1FF") : Color(hex: "22A0FB")
        }
    }
    
    func textColor(for colorScheme: ColorScheme) -> Color {
        switch self {
        case .outlined:
            return colorScheme == .dark ? .white : .black
        case .ghost, .tinted:
            return colorScheme == .dark ? Color(hex: "45B1FF") : Color(hex: "22A0FB")
        case .filled:
            return colorScheme == .dark ? .black : .white
        }
    }
    
    func borderColor(for colorScheme: ColorScheme) -> Color? {
        switch self {
        case .outlined:
            return colorScheme == .dark ? Color(hex: "414149") : Color(hex: "D5D5D5")
        default:
            return nil
        }
    }
}

// MARK: - Filo Button
struct FiloButton: View {
    let title: String
    let size: FiloButtonSize
    let variant: FiloButtonVariant
    let icon: Image?
    let action: () -> Void
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.isEnabled) var isEnabled
    
    init(
        _ title: String,
        size: FiloButtonSize = .medium,
        variant: FiloButtonVariant = .filled,
        icon: Image? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.size = size
        self.variant = variant
        self.icon = icon
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: icon != nil ? (size == .small ? 2 : 8) : 0) {
                if let icon = icon {
                    icon
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: size.iconSize, height: size.iconSize)
                }
                
                Text(title)
                    .font(.system(size: size.fontSize, weight: size.fontWeight))
                    .tracking(-0.2)
            }
            .foregroundColor(variant.textColor(for: colorScheme))
            .padding(.horizontal, icon != nil && size == .small ? 8 : size.paddingHorizontal)
            .padding(.trailing, icon != nil && size == .small ? 12 : size.paddingHorizontal)
            .padding(.vertical, size.paddingVertical)
            .frame(width: size.width)
            .background(variant.backgroundColor(for: colorScheme))
            .overlay(
                RoundedRectangle(cornerRadius: 100)
                    .stroke(variant.borderColor(for: colorScheme) ?? .clear, lineWidth: 0.5)
            )
            .clipShape(RoundedRectangle(cornerRadius: 100))
        }
        .buttonStyle(FiloButtonStyle())
        .opacity(isEnabled ? 1 : 0.5)
    }
}

// MARK: - Button Style
struct FiloButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .opacity(configuration.isPressed ? 0.8 : 1)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Google Sign In Button
struct FiloGoogleButton: View {
    let action: () -> Void
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        FiloButton(
            "Sign in with Google",
            size: .large,
            variant: .outlined,
            icon: Image("google"), // Requires google icon in assets
            action: action
        )
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        // Sizes
        Group {
            FiloButton("Small", size: .small, variant: .filled) {}
            FiloButton("Medium", size: .medium, variant: .filled) {}
            FiloButton("Large", size: .large, variant: .filled) {}
        }
        
        Divider()
        
        // Variants
        Group {
            FiloButton("Outlined", size: .medium, variant: .outlined) {}
            FiloButton("Ghost", size: .medium, variant: .ghost) {}
            FiloButton("Tinted", size: .medium, variant: .tinted) {}
            FiloButton("Filled", size: .medium, variant: .filled) {}
        }
        
        Divider()
        
        // With Icon
        FiloButton(
            "label-prompt",
            size: .small,
            variant: .ghost,
            icon: Image(systemName: "plus.circle")
        ) {}
        
        // Disabled
        FiloButton("Disabled", size: .medium, variant: .filled) {}
            .disabled(true)
    }
    .padding()
}

// MARK: - Color Extension (if not already defined)
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
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
