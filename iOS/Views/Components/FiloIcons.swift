//
//  FiloIcons.swift
//  Filo
//
//  Icon system for Filo iOS (183 icons)
//  Source: Resources/Icons/Library/ (exported from Figma)
//

import SwiftUI

// MARK: - Filo Icon Names

/// All icons from Filo's icon library
/// Path: Resources/Icons/Library/Property 1=[name].svg
enum FiloIconName: String, CaseIterable {
    
    // MARK: - Navigation (21)
    case gobackward
    case goforward
    case previous
    case next
    case menu
    case menuCollapse = "menu-collapse"
    case menuExpand = "menu-expand"
    case closeMinimal = "close-minimal"
    case closeStrong = "close-strong"
    case closeWeak = "close-weak"
    case expand
    case collapse
    case moreHorizontal = "more-horizontal"
    case moreVertical = "more-vertical"
    case search
    case searchAi = "search-ai"
    case filter
    case smartfilter
    case scrollup
    case arrowDualLeft = "arrow-dual-left"
    case arrowDualRight = "arrow-dual-right"
    
    // MARK: - Actions (27)
    case starBefore = "star-before"
    case starAfter = "star-after"
    case archive
    case delete
    case deletePermanently = "delete-permanently"
    case share
    case copy = "dopy"
    case edit
    case pencil
    case download
    case save
    case refresh
    case reorder
    case swipe
    case insert
    case add
    case addCircle = "add-circle"
    case subtract
    case minusCircle = "minus-circle"
    case checkmark
    case checkCircle = "check-circle"
    case checkFillcircle = "check-fillcircle"
    case checkboxChecked = "checkbox-checked"
    case checkboxUnchecked = "checkbox-unchecked"
    case checkboxMono = "checkbox-mono"
    case selectCircle = "select-circle"
    
    // MARK: - Email (28)
    case inboxBefore = "inbox-before"
    case inboxAfter = "inbox-after"
    case envelope
    case envelopeCheck = "envelope-check"
    case envelopAi = "envelop-ai"
    case read
    case unread
    case compose
    case draft
    case allmail
    case sent
    case scheduled
    case reply
    case replyMini = "reply-mini"
    case replyLine = "reply-line"
    case replyAll = "reply-all"
    case replyallMini = "replyall-mini"
    case replyallLine = "replyall-line"
    case forward
    case forwardMini = "forward-mini"
    case forwardLine = "forward-line"
    case sendEmail = "send-email"
    case sendMessage = "send-message"
    case attachment
    case spam
    case discard
    case markasdone
    
    // MARK: - Labels (6)
    case label
    case labelGmail = "label-gmail"
    case labelImportant = "label-important"
    case labelUnimportant = "label-unimportant"
    case labelPromotions = "label-promotions"
    case labelUpdates = "label-updates"
    
    // MARK: - AI (13)
    case aiMain = "ai-main"
    case ai2nd = "ai-2nd"
    case generateAi = "generate-ai"
    case summary
    case proofread
    case translate
    case lightbulb
    case longer
    case shorter
    case stytle
    case professional
    case friendly
    case sad
    
    // MARK: - Status (14)
    case info
    case error
    case question
    case loading
    case todo
    case todoOff = "todo-off"
    case like
    case notificationOn = "notification-on"
    case notificationOff = "notification-off"
    case thumbsupBefore = "thumbsup-before"
    case thumbsupAfter = "thumbsup-after"
    case thumbsdownBefore = "thumbsdown-before"
    case thumbsdownAfter = "thumbsdown-after"
    
    // MARK: - Media (14)
    case microphone
    case microphoneCircle = "microphone-circle"
    case play
    case pause
    case stop
    case videoPause = "video-pause"
    case videoReplay = "video-replay"
    case volumeOff = "Volumn_Off"
    case volumeLow = "Volumn_Low"
    case volumeMedium = "Volumn_Medium"
    case volumeHigh = "Volumn_High"
    case audio
    case image
    case camera
    
    // MARK: - Files (5)
    case file
    case document1 = "document-1"
    case document2 = "document-2"
    case pdf
    case zip
    
    // MARK: - Formatting (14)
    case boldtext
    case italic
    case underline
    case strikethrough
    case link
    case linkExternal = "link-external"
    case alignLeft = "align-left"
    case alignCenter = "align-center"
    case alignRight = "align-right"
    case bulletlist
    case numberlist
    case bullet
    case format
    case fontsize
    
    // MARK: - Window (5)
    case fullscreenEnter = "fullscreen-enter"
    case fullscreenExit = "fullscreen-exit"
    case minimizescreen
    case windowFloating = "window-floating"
    case windowSidebar = "window-sidebar"
    
    // MARK: - Settings (15)
    case settings
    case customize
    case theme
    case darkmode
    case lightmode
    case language
    case privacy
    case security
    case encryption
    case billing
    case signature
    case shortcut
    case eye
    case eyeSlash = "eye-slash"
    case block
    
    // MARK: - Account (5)
    case signout
    case switchAccount = "switch"
    case filoplus
    case filoplusMono = "filoplus-mono"
    case appicon
    
    // MARK: - Time (5)
    case clock
    case calendar
    case history
    case cursorBegin = "cursor-begin"
    case cursorEnd = "cursor-end"
    
    // MARK: - Social (5)
    case twitter
    case discord
    case telegram
    case imessage
    case youtube
    
    // MARK: - Feedback (10)
    case support
    case reportissue
    case changelog
    case chat
    case clearchat
    case fift
    case clap
    case coffee
    case terms
    
    /// Asset name in Xcode (includes "Property 1=" prefix)
    var assetName: String {
        "Property 1=\(rawValue)"
    }
}

// MARK: - Icon Provider

struct FiloIcon {
    
    /// Returns an icon image view from the Library
    @ViewBuilder
    static func icon(_ name: FiloIconName, size: CGFloat = 24) -> some View {
        Image(name.assetName)
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size, height: size)
    }
    
    /// Returns the asset name
    static func assetName(_ icon: FiloIconName) -> String {
        icon.assetName
    }
    
    // MARK: - Predefined Sizes
    
    enum Size: CGFloat {
        case small = 16
        case medium = 20
        case large = 24
        case xlarge = 32
    }
    
    static func icon(_ name: FiloIconName, size: Size) -> some View {
        icon(name, size: size.rawValue)
    }
}

// MARK: - Quick Access (Common Icons)

extension FiloIcon {
    // Navigation
    static var back: some View { icon(.gobackward) }
    static var close: some View { icon(.closeStrong) }
    static var menu: some View { icon(.menu) }
    static var moreHorizontal: some View { icon(.moreHorizontal) }
    static var search: some View { icon(.search) }
    
    // Actions
    static var star: some View { icon(.starBefore) }
    static var starFill: some View { icon(.starAfter) }
    static var archive: some View { icon(.archive) }
    static var trash: some View { icon(.delete) }
    static var share: some View { icon(.share) }
    
    // Email
    static var inbox: some View { icon(.inboxBefore) }
    static var compose: some View { icon(.compose) }
    static var reply: some View { icon(.reply) }
    static var replyAll: some View { icon(.replyAll) }
    static var forward: some View { icon(.forward) }
    static var send: some View { icon(.sendEmail) }
    static var attachment: some View { icon(.attachment) }
    
    // AI
    static var ai: some View { icon(.aiMain) }
    static var generateAi: some View { icon(.generateAi) }
    static var summary: some View { icon(.summary) }
    
    // Status
    static var info: some View { icon(.info) }
    static var error: some View { icon(.error) }
    static var check: some View { icon(.checkmark) }
    
    // Settings
    static var settings: some View { icon(.settings) }
}

// MARK: - Preview

#if DEBUG
#Preview("Filo Icon Library (183)") {
    NavigationStack {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(FiloIconName.allCases, id: \.self) { iconName in
                    VStack(spacing: 4) {
                        FiloIcon.icon(iconName, size: 20)
                            .foregroundStyle(.primary)
                        
                        Text(iconName.rawValue)
                            .font(.system(size: 7))
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                            .truncationMode(.middle)
                    }
                    .frame(height: 44)
                }
            }
            .padding()
        }
        .navigationTitle("181 Icons")
        .navigationBarTitleDisplayMode(.inline)
    }
}
#endif
