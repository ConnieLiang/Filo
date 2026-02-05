//
//  OnboardingView.swift
//  Filo
//
//  Main container for the Onboarding flow
//  Jira: FILO-1616
//

import SwiftUI

struct OnboardingView: View {
    @State private var viewModel = OnboardingViewModel()
    
    var body: some View {
        ZStack {
            // Background
            Color.filoBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // AI Header
                OnboardingAIHeader(
                    message: viewModel.currentStep.aiMessage,
                    isProcessing: viewModel.currentStep == .processing
                )
                .padding(.top, 60)
                .padding(.horizontal, 24)
                
                Spacer()
                
                // Step Content
                Group {
                    switch viewModel.currentStep {
                    case .processing:
                        OnboardingProcessingView(viewModel: viewModel)
                    case .importantEmails:
                        OnboardingImportantEmailsView(viewModel: viewModel)
                    case .todos:
                        OnboardingTodosView(viewModel: viewModel)
                    case .labels:
                        OnboardingLabelsView(viewModel: viewModel)
                    case .aiReply:
                        OnboardingReplyView(viewModel: viewModel)
                    case .complete:
                        OnboardingCompleteView(viewModel: viewModel)
                    }
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
                .animation(.easeInOut(duration: 0.3), value: viewModel.currentStep)
                
                Spacer()
            }
        }
        .onAppear {
            viewModel.startProcessing()
        }
    }
}

// MARK: - AI Header

struct OnboardingAIHeader: View {
    let message: String
    var isProcessing: Bool = false
    
    @State private var displayedMessage: String = ""
    @State private var showCursor: Bool = true
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // AI Avatar
            ZStack {
                Circle()
                    .fill(Color.filoPrimary)
                    .frame(width: 40, height: 40)
                
                SparkleIconWhite()
                    .frame(width: 18, height: 18)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text("Filo AI")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.filoTextPrimary)
                    
                    if isProcessing {
                        Text("Working on your inbox")
                            .font(.system(size: 13))
                            .foregroundColor(.filoTextSecondary)
                    }
                }
                
                // AI Message with typing effect
                HStack(spacing: 0) {
                    Text(displayedMessage)
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.filoTextPrimary)
                    
                    if displayedMessage.count < message.count {
                        Text("|")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(.filoPrimary)
                            .opacity(showCursor ? 1 : 0)
                    }
                }
            }
            
            Spacer()
        }
        .onChange(of: message) { _, newMessage in
            animateMessage(newMessage)
        }
        .onAppear {
            animateMessage(message)
            startCursorBlink()
        }
    }
    
    private func animateMessage(_ text: String) {
        displayedMessage = ""
        var index = 0
        let characters = Array(text)
        
        Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { timer in
            if index < characters.count {
                displayedMessage += String(characters[index])
                index += 1
            } else {
                timer.invalidate()
            }
        }
    }
    
    private func startCursorBlink() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            showCursor.toggle()
        }
    }
}

// MARK: - Sparkle Icon

struct SparkleIconWhite: View {
    var body: some View {
        Canvas { context, size in
            let w = size.width
            let h = size.height
            
            let path = Path { p in
                p.move(to: CGPoint(x: w * 0.5, y: 0))
                p.addQuadCurve(
                    to: CGPoint(x: w, y: h * 0.5),
                    control: CGPoint(x: w * 0.5, y: h * 0.5)
                )
                p.addQuadCurve(
                    to: CGPoint(x: w * 0.5, y: h),
                    control: CGPoint(x: w * 0.5, y: h * 0.5)
                )
                p.addQuadCurve(
                    to: CGPoint(x: 0, y: h * 0.5),
                    control: CGPoint(x: w * 0.5, y: h * 0.5)
                )
                p.addQuadCurve(
                    to: CGPoint(x: w * 0.5, y: 0),
                    control: CGPoint(x: w * 0.5, y: h * 0.5)
                )
                p.closeSubpath()
            }
            context.fill(path, with: .color(.white))
        }
    }
}

// MARK: - Preview

#Preview {
    OnboardingView()
}
