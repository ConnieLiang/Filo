import SwiftUI

// MARK: - Filo Color System
// 25 color tokens with light/dark mode support
// Source: Design Guidelines/Colors/colors.json

extension Color {
    
    // MARK: - Primary Colors
    
    /// Primary Light - #1F9EFA (light) / #6CC1FF (dark)
    static let filo01 = Color("Filo01")
    
    /// Primary Brand Color - #22A0FB (light) / #45B1FF (dark)
    static let filo02 = Color("Filo02")
    
    /// Primary Dark - #4BACF5 (light) / #213D51 (dark)
    static let filo03 = Color("Filo03")
    
    /// Primary Darker - #5ABEFF (light) / #2E5168 (dark)
    static let filo04 = Color("Filo04")
    
    /// Surface Secondary - #E8EEF2 (light) / #344352 (dark)
    static let filo05 = Color("Filo05")
    
    // MARK: - Text Colors
    
    /// Text Primary - #000000 (light) / #FFFFFF (dark)
    static let filo06 = Color("Filo06")
    
    /// Text Secondary - #707070 (light) / #8B8B8B (dark)
    static let filo07 = Color("Filo07")
    
    /// Text Tertiary - #999999 (light) / #414149 (dark)
    static let filo08 = Color("Filo08")
    
    // MARK: - Surface Colors
    
    /// Surface Tertiary - #F5F5F5 (light) / #2A2A30 (dark)
    static let filo09 = Color("Filo09")
    
    /// Background - #FFFFFF (light) / #1D1D21 (dark)
    static let filo10 = Color("Filo10")
    
    // MARK: - Semantic Colors
    
    /// Error - #E53935 (light) / #BE424D (dark)
    static let filo11 = Color("Filo11")
    
    /// Warning - #FFB800 (light) / #FFDC84 (dark)
    static let filo12 = Color("Filo12")
    
    /// Info - #22A0FB (light) / #3DAEFF (dark)
    static let filo13 = Color("Filo13")
    
    // MARK: - Overlay Colors
    
    /// Overlay Light - rgba(0,0,0,0.04) (light) / rgba(255,255,255,0.06) (dark)
    static let filo14 = Color("Filo14")
    
    /// Overlay Primary - rgba(34,160,251,0.08) (light) / rgba(76,180,255,0.12) (dark)
    static let filo15 = Color("Filo15")
    
    /// Overlay Subtle - rgba(0,0,0,0.02) (light) / rgba(75,91,103,0.08) (dark)
    static let filo16 = Color("Filo16")
    
    // MARK: - Status Colors
    
    /// Success Light - #E8F5CE (light) / #9BB26C (dark)
    static let filo17 = Color("Filo17")
    
    /// Success - #7EBA02 (both modes)
    static let filo18 = Color("Filo18")
    
    /// Warning Alt - #F7A501 (both modes)
    static let filo19 = Color("Filo19")
    
    /// Error Light - #FFE5E7 (light) / #461D21 (dark)
    static let filo20 = Color("Filo20")
    
    // MARK: - Accent Colors
    
    /// Purple Light - #E8E6F5 (light) / #B4AEDC (dark)
    static let filo21 = Color("Filo21")
    
    /// Purple - #7F6EFF (both modes)
    static let filo22 = Color("Filo22")
    
    /// Pink Light - #FFF0F5 (light) / #F6D4FF (dark)
    static let filo23 = Color("Filo23")
    
    /// Pink - #BF3EE2 (both modes)
    static let filo24 = Color("Filo24")
    
    /// Neutral - #9E9E9E (light) / #727272 (dark)
    static let filo25 = Color("Filo25")
}

// MARK: - Semantic Aliases

extension Color {
    /// Primary brand color (alias for filo02)
    static let filoPrimary = filo02
    
    /// Secondary brand color (alias for filo01)
    static let filoSecondary = filo01
    
    /// Primary background (alias for filo10)
    static let filoBackground = filo10
    
    /// Surface color (alias for filo09)
    static let filoSurface = filo09
    
    /// Primary text (alias for filo06)
    static let filoTextPrimary = filo06
    
    /// Secondary text (alias for filo07)
    static let filoTextSecondary = filo07
    
    /// Tertiary text (alias for filo08)
    static let filoTextTertiary = filo08
    
    /// Error color (alias for filo11)
    static let filoError = filo11
    
    /// Warning color (alias for filo12)
    static let filoWarning = filo12
    
    /// Success color (alias for filo18)
    static let filoSuccess = filo18
    
    /// Info color (alias for filo13)
    static let filoInfo = filo13
    
    /// Overlay color (alias for filo14)
    static let filoOverlay = filo14
}

// MARK: - Hex Color Initialization

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

// MARK: - Hardcoded Colors (Fallback)
// Use these if Asset Catalog colors are not set up

extension Color {
    struct FiloLight {
        static let c01 = Color(hex: "#1F9EFA")
        static let c02 = Color(hex: "#22A0FB")
        static let c03 = Color(hex: "#4BACF5")
        static let c04 = Color(hex: "#5ABEFF")
        static let c05 = Color(hex: "#E8EEF2")
        static let c06 = Color(hex: "#000000")
        static let c07 = Color(hex: "#707070")
        static let c08 = Color(hex: "#999999")
        static let c09 = Color(hex: "#F5F5F5")
        static let c10 = Color(hex: "#FFFFFF")
        static let c11 = Color(hex: "#E53935")
        static let c12 = Color(hex: "#FFB800")
        static let c13 = Color(hex: "#22A0FB")
        static let c14 = Color.black.opacity(0.04)
        static let c15 = Color(hex: "#22A0FB").opacity(0.08)
        static let c16 = Color.black.opacity(0.02)
        static let c17 = Color(hex: "#E8F5CE")
        static let c18 = Color(hex: "#7EBA02")
        static let c19 = Color(hex: "#F7A501")
        static let c20 = Color(hex: "#FFE5E7")
        static let c21 = Color(hex: "#E8E6F5")
        static let c22 = Color(hex: "#7F6EFF")
        static let c23 = Color(hex: "#FFF0F5")
        static let c24 = Color(hex: "#BF3EE2")
        static let c25 = Color(hex: "#9E9E9E")
    }
    
    struct FiloDark {
        static let c01 = Color(hex: "#6CC1FF")
        static let c02 = Color(hex: "#45B1FF")
        static let c03 = Color(hex: "#213D51")
        static let c04 = Color(hex: "#2E5168")
        static let c05 = Color(hex: "#344352")
        static let c06 = Color(hex: "#FFFFFF")
        static let c07 = Color(hex: "#8B8B8B")
        static let c08 = Color(hex: "#414149")
        static let c09 = Color(hex: "#2A2A30")
        static let c10 = Color(hex: "#1D1D21")
        static let c11 = Color(hex: "#BE424D")
        static let c12 = Color(hex: "#FFDC84")
        static let c13 = Color(hex: "#3DAEFF")
        static let c14 = Color.white.opacity(0.06)
        static let c15 = Color(hex: "#4CB4FF").opacity(0.12)
        static let c16 = Color(hex: "#4B5B67").opacity(0.08)
        static let c17 = Color(hex: "#9BB26C")
        static let c18 = Color(hex: "#7EBA02")
        static let c19 = Color(hex: "#F7A501")
        static let c20 = Color(hex: "#461D21")
        static let c21 = Color(hex: "#B4AEDC")
        static let c22 = Color(hex: "#7F6EFF")
        static let c23 = Color(hex: "#F6D4FF")
        static let c24 = Color(hex: "#BF3EE2")
        static let c25 = Color(hex: "#727272")
    }
}
