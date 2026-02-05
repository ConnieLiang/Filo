//
//  OnboardingLabelsView.swift
//  Filo
//
//  Step 3: Label suggestions
//  Jira: FILO-1616
//

import SwiftUI

struct OnboardingLabelsView: View {
    @Bindable var viewModel: OnboardingViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            // Labels grid
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)
                ], spacing: 12) {
                    ForEach(viewModel.suggestedLabels) { label in
                        LabelCard(
                            label: label,
                            onToggle: { viewModel.toggleLabelSelection(label) }
                        )
                    }
                }
                .padding(.horizontal, 24)
            }
            
            // Action buttons
            OnboardingActionButtons(
                skipTitle: "Skip this",
                confirmTitle: "Create these",
                confirmCount: viewModel.selectedLabelsCount,
                onSkip: { viewModel.skipCurrentStep() },
                onConfirm: { viewModel.confirmCurrentStep() }
            )
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
    }
}

// MARK: - Label Card

struct LabelCard: View {
    let label: OnboardingLabel
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            VStack(spacing: 12) {
                // Label icon
                ZStack {
                    Circle()
                        .fill(label.color.opacity(0.15))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: "tag.fill")
                        .font(.system(size: 20))
                        .foregroundColor(label.color)
                }
                
                // Label name
                Text(label.name)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.filoTextPrimary)
                
                // Email count
                Text("\(label.emailCount) emails")
                    .font(.system(size: 12))
                    .foregroundColor(.filoTextSecondary)
                
                // Selection indicator
                if label.isSelected {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark")
                            .font(.system(size: 10, weight: .bold))
                        Text("Selected")
                            .font(.system(size: 11, weight: .medium))
                    }
                    .foregroundColor(.filoPrimary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(Color.filoPrimary.opacity(0.1))
                    )
                } else {
                    Text("Tap to select")
                        .font(.system(size: 11))
                        .foregroundColor(.filoTextTertiary)
                        .padding(.vertical, 4)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.filoSurface)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(label.isSelected ? Color.filoPrimary : Color.clear, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.filoBackground.ignoresSafeArea()
        OnboardingLabelsView(viewModel: OnboardingViewModel())
    }
}
