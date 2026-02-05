//
//  OnboardingCompleteView.swift
//  Filo
//
//  Step 5: Completion screen
//  Jira: FILO-1616
//

import SwiftUI

struct OnboardingCompleteView: View {
    @Bindable var viewModel: OnboardingViewModel
    
    @State private var showStats = false
    @State private var checkmarkScale: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 32) {
            // Success animation
            ZStack {
                Circle()
                    .fill(Color.filoSuccess.opacity(0.1))
                    .frame(width: 100, height: 100)
                
                Image(systemName: "checkmark")
                    .font(.system(size: 44, weight: .bold))
                    .foregroundColor(.filoSuccess)
                    .scaleEffect(checkmarkScale)
            }
            
            // Stats grid
            if showStats {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    StatCard(
                        icon: "envelope.fill",
                        value: "\(viewModel.emailsProcessed)",
                        label: "Emails marked",
                        color: .filoPrimary
                    )
                    
                    StatCard(
                        icon: "checklist",
                        value: "\(viewModel.todosCreated)",
                        label: "Todos created",
                        color: .filoSuccess
                    )
                    
                    StatCard(
                        icon: "tag.fill",
                        value: "\(viewModel.labelsCreated)",
                        label: "Labels created",
                        color: .filo22
                    )
                    
                    StatCard(
                        icon: "doc.text.fill",
                        value: "\(viewModel.draftsCreated)",
                        label: "Drafts saved",
                        color: .filo19
                    )
                }
                .padding(.horizontal, 24)
                .transition(.opacity.combined(with: .scale(scale: 0.9)))
            }
            
            Spacer()
            
            // Action buttons
            VStack(spacing: 12) {
                // Add account button (secondary)
                Button(action: { viewModel.addAnotherAccount() }) {
                    HStack(spacing: 8) {
                        Image(systemName: "plus")
                            .font(.system(size: 14, weight: .semibold))
                        Text("Add account")
                            .font(.system(size: 15, weight: .semibold))
                    }
                    .foregroundColor(.filoPrimary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(
                        RoundedRectangle(cornerRadius: 26)
                            .stroke(Color.filoPrimary, lineWidth: 1.5)
                    )
                }
                
                // Let's go button (primary)
                Button(action: { viewModel.finishOnboarding() }) {
                    Text("Let's go!")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(
                            RoundedRectangle(cornerRadius: 26)
                                .fill(Color.filoPrimary)
                        )
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6).delay(0.2)) {
                checkmarkScale = 1
            }
            withAnimation(.easeOut(duration: 0.4).delay(0.5)) {
                showStats = true
            }
        }
    }
}

// MARK: - Stat Card

struct StatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            // Icon
            ZStack {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(color)
            }
            
            // Value
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.filoTextPrimary)
            
            // Label
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(.filoTextSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.filoSurface)
        )
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.filoBackground.ignoresSafeArea()
        OnboardingCompleteView(viewModel: OnboardingViewModel())
    }
}
