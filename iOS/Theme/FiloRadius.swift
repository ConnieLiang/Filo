import SwiftUI

// MARK: - Filo Corner Radius System
// 4-step scale + pill: 16, 20, 24, 30, 999
// Rule: Single-line cells always use pill (999)
// Source: Design Guidelines/Radius/radius.json

struct FiloRadius {
    
    // MARK: - Radius Scale
    
    /// 16px - Small radius (buttons, inputs, small cards)
    static let radius1: CGFloat = 16
    
    /// 20px - Medium radius (cards, modals, containers)
    static let radius2: CGFloat = 20
    
    /// 24px - Large radius (large cards, sheets)
    static let radius3: CGFloat = 24
    
    /// 30px - Extra large radius (feature cards, hero elements)
    static let radius4: CGFloat = 30
    
    /// 999px - Pill shape (single-line cells, tags, chips, tab bars)
    static let pill: CGFloat = 999
    
    // MARK: - Semantic Aliases
    
    /// Button corner radius (16px)
    static let button = radius1
    
    /// Pill button - use Capsule() or this value
    static let buttonPill = pill
    
    /// Input field corner radius (16px)
    static let input = radius1
    
    /// Card corner radius (20px)
    static let card = radius2
    
    /// Modal corner radius (24px)
    static let modal = radius3
    
    /// Bottom sheet corner radius (30px)
    static let sheet = radius4
    
    /// Tag/chip corner radius (pill)
    static let tag = pill
    
    /// Suggestion pill radius (pill - single line)
    static let suggestion = pill
    
    /// Tab bar glass container (pill)
    static let tabBar = pill
    
    /// Avatar (circular)
    static let avatar = pill
    
    /// Badge corner radius (pill)
    static let badge = pill
}

// MARK: - RoundedRectangle Convenience

extension RoundedRectangle {
    
    /// Standard button shape (16px)
    static let filoButton = RoundedRectangle(cornerRadius: FiloRadius.button)
    
    /// Card shape (20px)
    static let filoCard = RoundedRectangle(cornerRadius: FiloRadius.card)
    
    /// Modal shape (24px)
    static let filoModal = RoundedRectangle(cornerRadius: FiloRadius.modal)
    
    /// Sheet shape (30px)
    static let filoSheet = RoundedRectangle(cornerRadius: FiloRadius.sheet)
    
    /// Pill shape (999px) - prefer Capsule() for true pills
    static let filoPill = RoundedRectangle(cornerRadius: FiloRadius.pill)
}

// MARK: - View Extension

extension View {
    
    /// Apply button corner radius (16px)
    func filoButtonRadius() -> some View {
        self.clipShape(RoundedRectangle(cornerRadius: FiloRadius.button))
    }
    
    /// Apply card corner radius (20px)
    func filoCardRadius() -> some View {
        self.clipShape(RoundedRectangle(cornerRadius: FiloRadius.card))
    }
    
    /// Apply modal corner radius (24px)
    func filoModalRadius() -> some View {
        self.clipShape(RoundedRectangle(cornerRadius: FiloRadius.modal))
    }
    
    /// Apply pill shape - use for single-line cells
    func filoPillShape() -> some View {
        self.clipShape(Capsule())
    }
    
    /// Apply sheet corner radius (30px top corners only)
    func filoSheetRadius() -> some View {
        self.clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: FiloRadius.sheet,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: FiloRadius.sheet
            )
        )
    }
}

// MARK: - Usage Guide
/*
 
 RULE: Single-line content = Pill shape (999)
 
 Examples:
 
 // Single-line suggestion pill
 Text("Summarize emails")
     .padding()
     .background(Color.filo14)
     .filoPillShape()
 
 // Multi-line card
 VStack {
     Text("Title")
     Text("Description")
 }
 .padding()
 .background(Color.filo10)
 .filoCardRadius()
 
 // Tab bar glass container
 HStack { ... }
     .background(.ultraThinMaterial)
     .filoPillShape()
 
 // Bottom sheet
 VStack { ... }
     .filoSheetRadius()
 
 */
