//
//  OnboardingViewModel.swift
//  Filo
//
//  ViewModel for the Onboarding flow - "Organizing Inbox"
//  Jira: FILO-1616
//

import SwiftUI

// MARK: - Models

struct OnboardingEmail: Identifiable {
    let id: String
    let sender: String
    let senderEmail: String
    let subject: String
    let preview: String
    let date: Date
    var isSelected: Bool = false
}

struct OnboardingTodo: Identifiable {
    let id: String
    let title: String
    let emailSubject: String
    var isCompleted: Bool = false
    var isDeleted: Bool = false
}

struct OnboardingLabel: Identifiable {
    let id: String
    let name: String
    let color: Color
    let emailCount: Int
    var isSelected: Bool = true
}

struct OnboardingPendingReply: Identifiable {
    let id: String
    let sender: String
    let senderEmail: String
    let subject: String
    let preview: String
    let date: Date
}

enum QuickReplyStyle: String, CaseIterable {
    case professional = "Professional"
    case friendly = "Friendly"
    case brief = "Brief"
    
    var icon: String {
        switch self {
        case .professional: return "briefcase"
        case .friendly: return "face.smiling"
        case .brief: return "bolt"
        }
    }
}

// MARK: - Onboarding Step

enum OnboardingStep: Int, CaseIterable {
    case processing = 0
    case importantEmails = 1
    case todos = 2
    case labels = 3
    case aiReply = 4
    case complete = 5
    
    var aiMessage: String {
        switch self {
        case .processing:
            return "Hey! Let me take a look at your inbox..."
        case .importantEmails:
            return "I found some emails you might have missed"
        case .todos:
            return "I pulled out some action items for you"
        case .labels:
            return "Here are some labels I'd suggest"
        case .aiReply:
            return "This one needs your reply"
        case .complete:
            return "All done! Your inbox is ready."
        }
    }
}

// MARK: - Processing Task

struct ProcessingTask: Identifiable {
    let id: String
    let message: String
    var isComplete: Bool = false
}

// MARK: - ViewModel

@Observable
class OnboardingViewModel {
    
    // MARK: - State
    
    var currentStep: OnboardingStep = .processing
    var isTransitioning: Bool = false
    
    // Processing state
    var processingTasks: [ProcessingTask] = [
        ProcessingTask(id: "sync", message: "Syncing your emails..."),
        ProcessingTask(id: "important", message: "Looking for important ones..."),
        ProcessingTask(id: "actions", message: "Extracting action items..."),
        ProcessingTask(id: "labels", message: "Suggesting some labels..."),
        ProcessingTask(id: "replies", message: "Checking for pending replies...")
    ]
    var currentProcessingIndex: Int = 0
    
    // Important emails
    var importantEmails: [OnboardingEmail] = []
    
    // Todos
    var todos: [OnboardingTodo] = []
    
    // Labels
    var suggestedLabels: [OnboardingLabel] = []
    
    // Pending reply
    var pendingReply: OnboardingPendingReply?
    var selectedReplyStyle: QuickReplyStyle?
    var generatedReply: String = ""
    var isGeneratingReply: Bool = false
    
    // Completion stats
    var emailsProcessed: Int = 0
    var todosCreated: Int = 0
    var labelsCreated: Int = 0
    var draftsCreated: Int = 0
    
    // MARK: - Computed Properties
    
    var selectedEmailsCount: Int {
        importantEmails.filter { $0.isSelected }.count
    }
    
    var activeTodosCount: Int {
        todos.filter { !$0.isDeleted && !$0.isCompleted }.count
    }
    
    var selectedLabelsCount: Int {
        suggestedLabels.filter { $0.isSelected }.count
    }
    
    var shouldSkipImportantEmails: Bool {
        importantEmails.isEmpty
    }
    
    var shouldSkipTodos: Bool {
        todos.isEmpty
    }
    
    var shouldSkipLabels: Bool {
        suggestedLabels.isEmpty
    }
    
    var shouldSkipAIReply: Bool {
        pendingReply == nil
    }
    
    // MARK: - Initialization
    
    init() {
        loadMockData()
    }
    
    // MARK: - Actions
    
    func startProcessing() {
        currentProcessingIndex = 0
        simulateProcessing()
    }
    
    private func simulateProcessing() {
        guard currentProcessingIndex < processingTasks.count else {
            // Processing complete, move to next step
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.moveToNextStep()
            }
            return
        }
        
        // Mark current task as complete after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.processingTasks[self.currentProcessingIndex].isComplete = true
            self.currentProcessingIndex += 1
            self.simulateProcessing()
        }
    }
    
    func toggleEmailSelection(_ email: OnboardingEmail) {
        if let index = importantEmails.firstIndex(where: { $0.id == email.id }) {
            importantEmails[index].isSelected.toggle()
        }
    }
    
    func markTodoComplete(_ todo: OnboardingTodo) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index].isCompleted = true
        }
    }
    
    func deleteTodo(_ todo: OnboardingTodo) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index].isDeleted = true
        }
    }
    
    func toggleLabelSelection(_ label: OnboardingLabel) {
        if let index = suggestedLabels.firstIndex(where: { $0.id == label.id }) {
            suggestedLabels[index].isSelected.toggle()
        }
    }
    
    func selectReplyStyle(_ style: QuickReplyStyle) {
        selectedReplyStyle = style
        generateReply(style: style)
    }
    
    private func generateReply(style: QuickReplyStyle) {
        isGeneratingReply = true
        generatedReply = ""
        
        let replies: [QuickReplyStyle: String] = [
            .professional: "Thank you for your email. I have reviewed the information and will follow up with the necessary details by end of day. Please let me know if you need anything else in the meantime.",
            .friendly: "Thanks for reaching out! I've taken a look at this and I'll get back to you with everything you need soon. Let me know if there's anything else I can help with! 😊",
            .brief: "Got it. Will review and follow up shortly."
        ]
        
        let fullReply = replies[style] ?? ""
        simulateTyping(fullReply)
    }
    
    private func simulateTyping(_ text: String) {
        var index = 0
        let characters = Array(text)
        
        Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { timer in
            if index < characters.count {
                self.generatedReply += String(characters[index])
                index += 1
            } else {
                timer.invalidate()
                self.isGeneratingReply = false
            }
        }
    }
    
    func skipCurrentStep() {
        moveToNextStep()
    }
    
    func confirmCurrentStep() {
        switch currentStep {
        case .importantEmails:
            emailsProcessed = selectedEmailsCount
        case .todos:
            todosCreated = activeTodosCount
        case .labels:
            labelsCreated = selectedLabelsCount
        case .aiReply:
            if !generatedReply.isEmpty {
                draftsCreated = 1
            }
        default:
            break
        }
        moveToNextStep()
    }
    
    func moveToNextStep() {
        isTransitioning = true
        
        var nextStep = OnboardingStep(rawValue: currentStep.rawValue + 1) ?? .complete
        
        // Skip steps based on data availability
        while nextStep != .complete {
            switch nextStep {
            case .importantEmails where shouldSkipImportantEmails:
                nextStep = OnboardingStep(rawValue: nextStep.rawValue + 1) ?? .complete
            case .todos where shouldSkipTodos:
                nextStep = OnboardingStep(rawValue: nextStep.rawValue + 1) ?? .complete
            case .labels where shouldSkipLabels:
                nextStep = OnboardingStep(rawValue: nextStep.rawValue + 1) ?? .complete
            case .aiReply where shouldSkipAIReply:
                nextStep = OnboardingStep(rawValue: nextStep.rawValue + 1) ?? .complete
            default:
                break
            }
            
            // Prevent infinite loop
            if nextStep.rawValue <= currentStep.rawValue + 1 || nextStep == .complete {
                break
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.currentStep = nextStep
            self.isTransitioning = false
        }
    }
    
    func addAnotherAccount() {
        // TODO: Implement add account flow
    }
    
    func finishOnboarding() {
        // TODO: Navigate to main inbox
    }
    
    // MARK: - Mock Data
    
    private func loadMockData() {
        // Mock important emails
        importantEmails = [
            OnboardingEmail(
                id: "1",
                sender: "Sarah Chen",
                senderEmail: "sarah@company.com",
                subject: "Q1 Budget Review - Action Required",
                preview: "Hi, I need your approval on the Q1 budget proposal by Friday...",
                date: Date().addingTimeInterval(-86400 * 2)
            ),
            OnboardingEmail(
                id: "2",
                sender: "Michael Park",
                senderEmail: "michael@client.com",
                subject: "Contract Renewal Discussion",
                preview: "Following up on our conversation about the contract terms...",
                date: Date().addingTimeInterval(-86400 * 3)
            ),
            OnboardingEmail(
                id: "3",
                sender: "HR Team",
                senderEmail: "hr@company.com",
                subject: "Benefits Enrollment Deadline",
                preview: "Reminder: Open enrollment closes this Friday at 5pm...",
                date: Date().addingTimeInterval(-86400 * 1)
            )
        ]
        
        // Mock todos
        todos = [
            OnboardingTodo(
                id: "1",
                title: "Review and approve Q1 budget",
                emailSubject: "Q1 Budget Review"
            ),
            OnboardingTodo(
                id: "2",
                title: "Schedule call with Michael re: contract",
                emailSubject: "Contract Renewal Discussion"
            ),
            OnboardingTodo(
                id: "3",
                title: "Complete benefits enrollment",
                emailSubject: "Benefits Enrollment Deadline"
            )
        ]
        
        // Mock labels
        suggestedLabels = [
            OnboardingLabel(id: "1", name: "Work", color: .blue, emailCount: 45),
            OnboardingLabel(id: "2", name: "Finance", color: .green, emailCount: 12),
            OnboardingLabel(id: "3", name: "HR", color: .purple, emailCount: 8),
            OnboardingLabel(id: "4", name: "Clients", color: .orange, emailCount: 23)
        ]
        
        // Mock pending reply
        pendingReply = OnboardingPendingReply(
            id: "1",
            sender: "David Kim",
            senderEmail: "david@partner.com",
            subject: "Partnership Proposal Follow-up",
            preview: "Hi, just wanted to check in on the proposal I sent last week...",
            date: Date().addingTimeInterval(-86400 * 4)
        )
    }
}
