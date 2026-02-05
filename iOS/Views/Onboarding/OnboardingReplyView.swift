//
//  OnboardingReplyView.swift
//  Filo
//
//  Step 4: AI Reply draft
//  Jira: FILO-1616
//

import SwiftUI

struct OnboardingReplyView: View {
    @Bindable var viewModel: OnboardingViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            // Pending email card
            if let email = viewModel.pendingReply {
                PendingReplyEmailCard(email: email)
                    .padding(.horizontal, 24)
            }
            
            // AI Reply section
            VStack(alignment: .leading, spacing: 16) {
                // Section header
                HStack(spacing: 8) {
                    SparkleIconWhite()
                        .frame(width: 14, height: 14)
                        .foregroundColor(.filoPrimary)
                    
                    Text("My draft for you")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.filoTextSecondary)
                }
                
                // Quick action buttons
                if viewModel.selectedReplyStyle == nil {
                    Text("Pick a response style below and I'll write it for you...")
                        .font(.system(size: 14))
                        .foregroundColor(.filoTextTertiary)
                        .padding(.vertical, 8)
                    
                    HStack(spacing: 10) {
                        ForEach(QuickReplyStyle.allCases, id: \.self) { style in
                            QuickReplyButton(style: style) {
                                viewModel.selectReplyStyle(style)
                            }
                        }
                    }
                } else {
                    // Generated reply
                    VStack(alignment: .leading, spacing: 12) {
                        // Selected style indicator
                        HStack(spacing: 6) {
                            Image(systemName: viewModel.selectedReplyStyle!.icon)
                                .font(.system(size: 12))
                            Text(viewModel.selectedReplyStyle!.rawValue)
                                .font(.system(size: 12, weight: .medium))
                        }
                        .foregroundColor(.filoPrimary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color.filoPrimary.opacity(0.1))
                        )
                        
                        // Reply text with typing effect
                        Text(viewModel.generatedReply)
                            .font(.system(size: 15))
                            .foregroundColor(.filoTextPrimary)
                            .lineSpacing(4)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.filoSurface)
                            )
                        
                        // Loading indicator
                        if viewModel.isGeneratingReply {
                            HStack(spacing: 6) {
                                ProgressView()
                                    .scaleEffect(0.7)
                                    .tint(.filoPrimary)
                                Text("Writing...")
                                    .font(.system(size: 12))
                                    .foregroundColor(.filoTextSecondary)
                            }
                        }
                    }
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.filoBackground)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
            )
            .padding(.horizontal, 24)
            
            Spacer()
            
            // Action buttons
            OnboardingActionButtons(
                skipTitle: "Skip this",
                confirmTitle: "Save draft",
                confirmCount: nil,
                confirmDisabled: viewModel.generatedReply.isEmpty || viewModel.isGeneratingReply,
                onSkip: { viewModel.skipCurrentStep() },
                onConfirm: { viewModel.confirmCurrentStep() }
            )
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
    }
}

// MARK: - Pending Reply Email Card

struct PendingReplyEmailCard: View {
    let email: OnboardingPendingReply
    
    var body: some View {
        HStack(spacing: 14) {
            // Avatar
            Circle()
                .fill(Color.filo05)
                .frame(width: 44, height: 44)
                .overlay(
                    Text(String(email.sender.prefix(1)))
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.filoTextPrimary)
                )
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(email.sender)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.filoTextPrimary)
                    
                    Spacer()
                    
                    Text(email.date.relativeString)
                        .font(.system(size: 12))
                        .foregroundColor(.filoTextTertiary)
                }
                
                Text(email.subject)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.filoTextPrimary)
                    .lineLimit(1)
                
                Text(email.preview)
                    .font(.system(size: 13))
                    .foregroundColor(.filoTextSecondary)
                    .lineLimit(2)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.filoSurface)
        )
    }
}

// MARK: - Quick Reply Button

struct QuickReplyButton: View {
    let style: QuickReplyStyle
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: style.icon)
                    .font(.system(size: 20))
                    .foregroundColor(.filoPrimary)
                
                Text(style.rawValue)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.filoTextPrimary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.filoSurface)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.filoBackground.ignoresSafeArea()
        OnboardingReplyView(viewModel: OnboardingViewModel())
    }
}
