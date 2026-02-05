//
//  OnboardingActionButtons.swift
//  Filo
//
//  Shared action buttons for onboarding steps
//  Jira: FILO-1616
//

import SwiftUI

struct OnboardingActionButtons: View {
    let skipTitle: String
    let confirmTitle: String
    var confirmCount: Int? = nil
    var confirmDisabled: Bool = false
    let onSkip: () -> Void
    let onConfirm: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Skip button
            Button(action: onSkip) {
                Text(skipTitle)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.filoTextSecondary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(
                        RoundedRectangle(cornerRadius: 26)
                            .fill(Color.filoSurface)
                    )
            }
            
            // Confirm button
            Button(action: onConfirm) {
                HStack(spacing: 6) {
                    Text(confirmTitle)
                        .font(.system(size: 15, weight: .bold))
                    
                    if let count = confirmCount, count > 0 {
                        Text("(\(count))")
                            .font(.system(size: 14, weight: .semibold))
                    }
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(
                    RoundedRectangle(cornerRadius: 26)
                        .fill(confirmDisabled ? Color.filoTextTertiary : Color.filoPrimary)
                )
            }
            .disabled(confirmDisabled)
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        OnboardingActionButtons(
            skipTitle: "Skip this",
            confirmTitle: "Mark these",
            confirmCount: 3,
            onSkip: {},
            onConfirm: {}
        )
        
        OnboardingActionButtons(
            skipTitle: "Skip this",
            confirmTitle: "Save draft",
            confirmCount: nil,
            confirmDisabled: true,
            onSkip: {},
            onConfirm: {}
        )
    }
    .padding()
    .background(Color.filoBackground)
}
