//
//  OnboardingImportantEmailsView.swift
//  Filo
//
//  Step 1: Important emails selection
//  Jira: FILO-1616
//

import SwiftUI

struct OnboardingImportantEmailsView: View {
    @Bindable var viewModel: OnboardingViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            // Email list
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(viewModel.importantEmails) { email in
                        ImportantEmailCard(
                            email: email,
                            onToggle: { viewModel.toggleEmailSelection(email) }
                        )
                    }
                }
                .padding(.horizontal, 24)
            }
            
            // Action buttons
            OnboardingActionButtons(
                skipTitle: "Skip this",
                confirmTitle: "Mark these",
                confirmCount: viewModel.selectedEmailsCount,
                onSkip: { viewModel.skipCurrentStep() },
                onConfirm: { viewModel.confirmCurrentStep() }
            )
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
    }
}

// MARK: - Important Email Card

struct ImportantEmailCard: View {
    let email: OnboardingEmail
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 14) {
                // Checkbox
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(email.isSelected ? Color.filoPrimary : Color.filoTextTertiary, lineWidth: 1.5)
                        .frame(width: 22, height: 22)
                    
                    if email.isSelected {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.filoPrimary)
                            .frame(width: 22, height: 22)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                
                // Avatar
                Circle()
                    .fill(Color.filo05)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text(String(email.sender.prefix(1)))
                            .font(.system(size: 16, weight: .semibold))
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
                        .lineLimit(1)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.filoSurface)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(email.isSelected ? Color.filoPrimary : Color.clear, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Date Extension

extension Date {
    var relativeString: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.filoBackground.ignoresSafeArea()
        OnboardingImportantEmailsView(viewModel: OnboardingViewModel())
    }
}
