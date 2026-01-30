import SwiftUI

// MARK: - Filo Spacing System
// 7-step spacing scale: 4, 8, 12, 16, 20, 30, 40
// Source: Design Guidelines/Spacing/spacing.json

struct FiloSpacing {
    
    // MARK: - Spacing Scale
    
    /// 4px - Micro spacing (icon padding, tight gaps)
    static let space1: CGFloat = 4
    
    /// 8px - Small spacing (related elements, button padding)
    static let space2: CGFloat = 8
    
    /// 12px - Medium-small (list item gaps, card padding)
    static let space3: CGFloat = 12
    
    /// 16px - Medium (section padding, standard gaps)
    static let space4: CGFloat = 16
    
    /// 20px - Medium-large (container padding, between sections)
    static let space5: CGFloat = 20
    
    /// 30px - Large (major section gaps)
    static let space6: CGFloat = 30
    
    /// 40px - Extra large (page margins, hero sections)
    static let space7: CGFloat = 40
    
    // MARK: - Semantic Aliases
    
    /// Icon internal padding (4px)
    static let iconPadding = space1
    
    /// Button vertical padding (8px)
    static let buttonPaddingY = space2
    
    /// Button horizontal padding (16px)
    static let buttonPaddingX = space4
    
    /// Card internal padding (16px)
    static let cardPadding = space4
    
    /// Gap between list items (12px)
    static let listItemGap = space3
    
    /// Gap between sections (20px)
    static let sectionGap = space5
    
    /// Page horizontal margin (20px)
    static let pageMargin = space5
    
    /// Modal/sheet padding (20px)
    static let modalPadding = space5
    
    /// Navigation header padding (16px)
    static let headerPadding = space4
    
    /// Input field padding (12px)
    static let inputPadding = space3
}

// MARK: - View Extension for Spacing

extension View {
    
    /// Apply standard card padding (16px)
    func filoCardPadding() -> some View {
        self.padding(FiloSpacing.cardPadding)
    }
    
    /// Apply standard page margin (20px horizontal)
    func filoPageMargin() -> some View {
        self.padding(.horizontal, FiloSpacing.pageMargin)
    }
    
    /// Apply section spacing below (20px)
    func filoSectionSpacing() -> some View {
        self.padding(.bottom, FiloSpacing.sectionGap)
    }
}

// MARK: - EdgeInsets Extension

extension EdgeInsets {
    
    /// Standard button padding (8px vertical, 16px horizontal)
    static let filoButton = EdgeInsets(
        top: FiloSpacing.buttonPaddingY,
        leading: FiloSpacing.buttonPaddingX,
        bottom: FiloSpacing.buttonPaddingY,
        trailing: FiloSpacing.buttonPaddingX
    )
    
    /// Standard card padding (16px all sides)
    static let filoCard = EdgeInsets(
        top: FiloSpacing.cardPadding,
        leading: FiloSpacing.cardPadding,
        bottom: FiloSpacing.cardPadding,
        trailing: FiloSpacing.cardPadding
    )
    
    /// Standard modal padding (20px all sides)
    static let filoModal = EdgeInsets(
        top: FiloSpacing.modalPadding,
        leading: FiloSpacing.modalPadding,
        bottom: FiloSpacing.modalPadding,
        trailing: FiloSpacing.modalPadding
    )
    
    /// Standard input padding (12px all sides)
    static let filoInput = EdgeInsets(
        top: FiloSpacing.inputPadding,
        leading: FiloSpacing.inputPadding,
        bottom: FiloSpacing.inputPadding,
        trailing: FiloSpacing.inputPadding
    )
}
