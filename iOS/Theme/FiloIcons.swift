import SwiftUI

// MARK: - Filo Icon Library
// 183 SVG icons organized by category
// Source: Resources/Icons/Library/

enum FiloIcon: String, CaseIterable {
    
    // MARK: - Navigation
    case inboxBefore = "inbox-before"
    case inboxAfter = "inbox-after"
    case todo = "todo"
    case todoOff = "todo-off"
    case compose = "compose"
    case aiMain = "ai-main"
    case ai2nd = "ai-2nd"
    case search = "search"
    case searchAi = "search-ai"
    case menuExpand = "menu-expand"
    case filter = "filter"
    case settings = "settings"
    case history = "history"
    
    // MARK: - Actions
    case reply = "reply"
    case replyAll = "reply-all"
    case forward = "forward"
    case archive = "archive"
    case delete = "delete"
    case deletePermanently = "delete-permanently"
    case spam = "spam"
    case discard = "discard"
    case edit = "edit"
    case save = "save"
    case share = "share"
    case download = "download"
    case refresh = "refresh"
    case copy = "dopy"
    
    // MARK: - Email
    case envelope = "envelope"
    case envelopeCheck = "envelope-check"
    case envelopAi = "envelop-ai"
    case sendEmail = "send-email"
    case sent = "sent"
    case scheduled = "scheduled"
    case draft = "draft"
    case allmail = "allmail"
    case read = "read"
    case unread = "unread"
    case attachment = "attachment"
    case starBefore = "star-before"
    case starAfter = "star-after"
    
    // MARK: - Labels
    case label = "label"
    case labelGmail = "label-gmail"
    case labelImportant = "label-important"
    case labelUnimportant = "label-unimportant"
    case labelUpdates = "label-updates"
    case labelPromotions = "label-promotions"
    
    // MARK: - AI Features
    case generateAi = "generate-ai"
    case summary = "summary"
    case proofread = "proofread"
    case translate = "translate"
    case style = "stytle"
    case professional = "professional"
    case friendly = "friendly"
    case sad = "sad"
    case longer = "longer"
    case shorter = "shorter"
    case smartfilter = "smartfilter"
    
    // MARK: - Formatting
    case boldtext = "boldtext"
    case italic = "italic"
    case underline = "underline"
    case strikethrough = "strikethrough"
    case fontsize = "fontsize"
    case alignLeft = "align-left"
    case alignCenter = "align-center"
    case alignRight = "align-right"
    case bulletlist = "bulletlist"
    case numberlist = "numberlist"
    case link = "link"
    case format = "format"
    
    // MARK: - Media
    case image = "image"
    case camera = "camera"
    case videoPause = "video-pause"
    case videoReplay = "video-replay"
    case play = "play"
    case pause = "pause"
    case stop = "stop"
    case audio = "audio"
    case microphone = "microphone"
    case microphoneCircle = "microphone-circle"
    case file = "file"
    case pdf = "pdf"
    case document1 = "document-1"
    case document2 = "document-2"
    case zip = "zip"
    
    // MARK: - UI Controls
    case closeMinimal = "close-minimal"
    case closeWeak = "close-weak"
    case closeStrong = "close-strong"
    case add = "add"
    case subtract = "subtract"
    case addCircle = "add-circle"
    case minusCircle = "minus-circle"
    case checkmark = "checkmark"
    case checkCircle = "check-circle"
    case checkFillcircle = "check-fillcircle"
    case checkboxUnchecked = "checkbox-unchecked"
    case checkboxChecked = "checkbox-checked"
    case checkboxMono = "checkbox-mono"
    case expand = "expand"
    case collapse = "collapse"
    case fullscreenEnter = "fullscreen-enter"
    case fullscreenExit = "fullscreen-exit"
    case minimizescreen = "minimizescreen"
    case moreHorizontal = "more-horizontal"
    case moreVertical = "more-vertical"
    case reorder = "reorder"
    case selectCircle = "select-circle"
    
    // MARK: - Arrows
    case goforward = "goforward"
    case gobackward = "gobackward"
    case previous = "previous"
    case next = "next"
    case scrollup = "scrollup"
    case arrowDualLeft = "arrow-dual-left"
    case arrowDualRight = "arrow-dual-right"
    case cursorBegin = "cursor-begin"
    case cursorEnd = "cursor-end"
    
    // MARK: - Communication
    case chat = "chat"
    case sendMessage = "send-message"
    case imessage = "imessage"
    case support = "support"
    case clearchat = "clearchat"
    
    // MARK: - Feedback
    case thumbsupBefore = "thumbsup-before"
    case thumbsupAfter = "thumbsup-after"
    case thumbsdownBefore = "thumbsdown-before"
    case thumbsdownAfter = "thumbsdown-after"
    case like = "like"
    case clap = "clap"
    case reportissue = "reportissue"
    
    // MARK: - Settings
    case customize = "customize"
    case notificationOn = "notification-on"
    case notificationOff = "notification-off"
    case darkmode = "darkmode"
    case lightmode = "lightmode"
    case theme = "theme"
    case language = "language"
    case privacy = "privacy"
    case security = "security"
    case encryption = "encryption"
    case terms = "terms"
    case billing = "billing"
    case signature = "signature"
    
    // MARK: - Social
    case twitter = "twitter"
    case discord = "discord"
    case telegram = "telegram"
    case youtube = "youtube"
    
    // MARK: - Volume
    case volumeHigh = "Volumn_High"
    case volumeMedium = "Volumn_Medium"
    case volumeLow = "Volumn_Low"
    case volumeOff = "Volumn_Off"
    
    // MARK: - Misc
    case calendar = "calendar"
    case clock = "clock"
    case coffee = "coffee"
    case lightbulb = "lightbulb"
    case info = "info"
    case question = "question"
    case error = "error"
    case bullet = "bullet"
    case swipe = "swipe"
    case block = "block"
    case eye = "eye"
    case eyeSlash = "eye-slash"
    case linkExternal = "link-external"
    case shortcut = "shortcut"
    case changelog = "changelog"
    case insert = "insert"
    case loading = "loading"
    case pencil = "pencil"
    case filoplus = "filoplus"
    case filoplusMono = "filoplus-mono"
    case appicon = "appicon"
    case markasdone = "markasdone"
    case fift = "fift"
    case switchIcon = "switch"
    case signout = "signout"
    case windowFloating = "window-floating"
    case windowSidebar = "window-sidebar"
}

// MARK: - Icon View Extension

extension FiloIcon {
    
    /// Returns an Image view for the icon
    var image: Image {
        Image(self.rawValue)
    }
    
    /// Returns a template-rendered Image for dynamic coloring
    func templateImage(color: Color = .filo06) -> some View {
        Image(self.rawValue)
            .renderingMode(.template)
            .foregroundColor(color)
    }
}

// MARK: - Convenience View

struct FiloIconView: View {
    let icon: FiloIcon
    var size: CGFloat = 24
    var color: Color = .filo06
    
    var body: some View {
        Image(icon.rawValue)
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .foregroundColor(color)
    }
}

// MARK: - Icon Pairs (State Variants)

struct FiloIconPair {
    let inactive: FiloIcon
    let active: FiloIcon
    
    static let inbox = FiloIconPair(inactive: .inboxBefore, active: .inboxAfter)
    static let star = FiloIconPair(inactive: .starBefore, active: .starAfter)
    static let thumbsUp = FiloIconPair(inactive: .thumbsupBefore, active: .thumbsupAfter)
    static let thumbsDown = FiloIconPair(inactive: .thumbsdownBefore, active: .thumbsdownAfter)
    static let todo = FiloIconPair(inactive: .todo, active: .todoOff)
    static let notification = FiloIconPair(inactive: .notificationOn, active: .notificationOff)
    static let checkbox = FiloIconPair(inactive: .checkboxUnchecked, active: .checkboxChecked)
    static let eye = FiloIconPair(inactive: .eye, active: .eyeSlash)
    static let fullscreen = FiloIconPair(inactive: .fullscreenEnter, active: .fullscreenExit)
    
    func icon(for isActive: Bool) -> FiloIcon {
        isActive ? active : inactive
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        HStack(spacing: 16) {
            FiloIconView(icon: .inboxBefore, color: .filo07)
            FiloIconView(icon: .todo, color: .filo07)
            FiloIconView(icon: .aiMain, color: .filo02)
            FiloIconView(icon: .compose, color: .filo02)
        }
        
        HStack(spacing: 16) {
            FiloIconView(icon: .reply)
            FiloIconView(icon: .archive)
            FiloIconView(icon: .delete, color: .filo11)
            FiloIconView(icon: .starAfter, color: .filo12)
        }
    }
    .padding()
}
