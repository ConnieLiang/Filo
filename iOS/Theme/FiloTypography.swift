import SwiftUI

// MARK: - Filo Typography System
// Complete type scale with SF Pro and New York Small fonts
// Source: Design Guidelines/Typography/typography.json

extension Font {
    
    // MARK: - Headers (SF Pro Bold)
    
    /// H1: SF Pro Bold, 40px, line-height 52, kerning 0.2
    static let filoH1 = Font.system(size: 40, weight: .bold)
    
    /// H2: SF Pro Bold, 32px, line-height 42, kerning 0.2
    static let filoH2 = Font.system(size: 32, weight: .bold)
    
    /// H3: SF Pro Bold, 28px, line-height 36, kerning 0.1
    static let filoH3 = Font.system(size: 28, weight: .bold)
    
    /// H4: SF Pro Bold, 26px, line-height 32, kerning 0
    static let filoH4 = Font.system(size: 26, weight: .bold)
    
    /// H5: SF Pro Bold, 22px, line-height 24, kerning 0
    static let filoH5 = Font.system(size: 22, weight: .bold)
    
    // MARK: - Paragraph Large (P1)
    
    /// P1_B: SF Pro Bold, 19px, line-height 26, kerning -0.2
    static let filoP1B = Font.system(size: 19, weight: .bold)
    
    /// P1_M: SF Pro Medium, 19px, line-height 26, kerning -0.2
    static let filoP1M = Font.system(size: 19, weight: .medium)
    
    // MARK: - Paragraph Body (P1.1)
    
    /// P1.1_B: SF Pro Bold, 17px, line-height 24, kerning -0.2
    static let filoP1_1B = Font.system(size: 17, weight: .bold)
    
    /// P1.1_R: SF Pro Regular, 17px, line-height 24, kerning -0.2
    static let filoP1_1R = Font.system(size: 17, weight: .regular)
    
    /// P1.1_R_Italic: SF Pro Regular Italic, 17px, line-height 24, kerning -0.2
    static let filoP1_1RItalic = Font.system(size: 17, weight: .regular).italic()
    
    // MARK: - Paragraph Serif (P1S) - New York Small
    
    /// P1S_B: New York Small Bold, 18px, line-height 27, kerning 0
    static let filoP1SB = Font.custom("NewYorkSmall-Bold", size: 18)
    
    /// P1S_M: New York Small Medium, 18px, line-height 27, kerning 0
    static let filoP1SM = Font.custom("NewYorkSmall-Medium", size: 18)
    
    // MARK: - Paragraph Standard (P2)
    
    /// P2_B: SF Pro Bold, 16px, line-height 20, kerning -0.2
    static let filoP2B = Font.system(size: 16, weight: .bold)
    
    /// P2_M: SF Pro Medium, 16px, line-height 20, kerning -0.2
    static let filoP2M = Font.system(size: 16, weight: .medium)
    
    /// P2_R: SF Pro Regular, 16px, line-height 20, kerning -0.2
    static let filoP2R = Font.system(size: 16, weight: .regular)
    
    // MARK: - Paragraph Standard Serif (P2S) - New York Small
    
    /// P2S_B: New York Small Bold, 16px, line-height 20, kerning 0
    static let filoP2SB = Font.custom("NewYorkSmall-Bold", size: 16)
    
    /// P2S_R: New York Small Regular, 16px, line-height 20, kerning 0
    static let filoP2SR = Font.custom("NewYorkSmall-Regular", size: 16)
    
    // MARK: - Paragraph Small (P3)
    
    /// P3_B: SF Pro Bold, 15px, line-height 20, kerning -0.2
    static let filoP3B = Font.system(size: 15, weight: .bold)
    
    /// P3_M: SF Pro Medium, 15px, line-height 20, kerning -0.2
    static let filoP3M = Font.system(size: 15, weight: .medium)
    
    /// P3_R: SF Pro Regular, 15px, line-height 20, kerning -0.2
    static let filoP3R = Font.system(size: 15, weight: .regular)
    
    /// P3.1_M: SF Pro Medium, 14px, line-height 18, kerning -0.2
    static let filoP3_1M = Font.system(size: 14, weight: .medium)
    
    // MARK: - Caption (P4)
    
    /// P4_B: SF Pro Bold, 13px, line-height 15, kerning 0
    static let filoP4B = Font.system(size: 13, weight: .bold)
    
    /// P4_R: SF Pro Regular, 13px, line-height 15, kerning 0
    static let filoP4R = Font.system(size: 13, weight: .regular)
    
    // MARK: - Micro (P5)
    
    /// P5_B: SF Pro Bold, 10px, line-height 12, kerning 0
    static let filoP5B = Font.system(size: 10, weight: .bold)
    
    /// P5_R: SF Pro Regular, 10px, line-height 12, kerning 0
    static let filoP5R = Font.system(size: 10, weight: .regular)
}

// MARK: - Typography Modifiers

extension View {
    
    /// Apply H1 typography with proper line height and kerning
    func filoH1Style() -> some View {
        self
            .font(.filoH1)
            .lineSpacing(52 - 40) // line-height - font-size
            .kerning(0.2)
    }
    
    /// Apply H2 typography with proper line height and kerning
    func filoH2Style() -> some View {
        self
            .font(.filoH2)
            .lineSpacing(42 - 32)
            .kerning(0.2)
    }
    
    /// Apply H3 typography with proper line height and kerning
    func filoH3Style() -> some View {
        self
            .font(.filoH3)
            .lineSpacing(36 - 28)
            .kerning(0.1)
    }
    
    /// Apply H4 typography with proper line height and kerning
    func filoH4Style() -> some View {
        self
            .font(.filoH4)
            .lineSpacing(32 - 26)
            .kerning(0)
    }
    
    /// Apply H5 typography with proper line height and kerning
    func filoH5Style() -> some View {
        self
            .font(.filoH5)
            .lineSpacing(24 - 22)
            .kerning(0)
    }
    
    /// Apply P1_B typography with proper line height and kerning
    func filoP1BStyle() -> some View {
        self
            .font(.filoP1B)
            .lineSpacing(26 - 19)
            .kerning(-0.2)
    }
    
    /// Apply P1_M typography with proper line height and kerning
    func filoP1MStyle() -> some View {
        self
            .font(.filoP1M)
            .lineSpacing(26 - 19)
            .kerning(-0.2)
    }
    
    /// Apply P2_R typography with proper line height and kerning
    func filoP2RStyle() -> some View {
        self
            .font(.filoP2R)
            .lineSpacing(20 - 16)
            .kerning(-0.2)
    }
    
    /// Apply P2_M typography with proper line height and kerning
    func filoP2MStyle() -> some View {
        self
            .font(.filoP2M)
            .lineSpacing(20 - 16)
            .kerning(-0.2)
    }
    
    /// Apply P2_B typography with proper line height and kerning
    func filoP2BStyle() -> some View {
        self
            .font(.filoP2B)
            .lineSpacing(20 - 16)
            .kerning(-0.2)
    }
    
    /// Apply P3_R typography with proper line height and kerning
    func filoP3RStyle() -> some View {
        self
            .font(.filoP3R)
            .lineSpacing(20 - 15)
            .kerning(-0.2)
    }
    
    /// Apply P4_R typography with proper line height and kerning
    func filoP4RStyle() -> some View {
        self
            .font(.filoP4R)
            .lineSpacing(15 - 13)
            .kerning(0)
    }
}

// MARK: - Typography Constants

struct FiloTypography {
    
    struct LineHeight {
        static let h1: CGFloat = 52
        static let h2: CGFloat = 42
        static let h3: CGFloat = 36
        static let h4: CGFloat = 32
        static let h5: CGFloat = 24
        static let p1: CGFloat = 26
        static let p1_1: CGFloat = 24
        static let p1s: CGFloat = 27
        static let p2: CGFloat = 20
        static let p3: CGFloat = 20
        static let p3_1: CGFloat = 18
        static let p4: CGFloat = 15
        static let p5: CGFloat = 12
    }
    
    struct Kerning {
        static let h1: CGFloat = 0.2
        static let h2: CGFloat = 0.2
        static let h3: CGFloat = 0.1
        static let h4: CGFloat = 0
        static let h5: CGFloat = 0
        static let p1: CGFloat = -0.2
        static let p1_1: CGFloat = -0.2
        static let p1s: CGFloat = 0
        static let p2: CGFloat = -0.2
        static let p2s: CGFloat = 0
        static let p3: CGFloat = -0.2
        static let p3_1: CGFloat = -0.2
        static let p4: CGFloat = 0
        static let p5: CGFloat = 0
    }
}
