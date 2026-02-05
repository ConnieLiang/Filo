//
//  OnboardingTodosView.swift
//  Filo
//
//  Step 2: Action items / todos
//  Jira: FILO-1616
//

import SwiftUI

struct OnboardingTodosView: View {
    @Bindable var viewModel: OnboardingViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            // Todo list
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(viewModel.todos.filter { !$0.isDeleted }) { todo in
                        TodoCard(
                            todo: todo,
                            onComplete: { viewModel.markTodoComplete(todo) },
                            onDelete: { viewModel.deleteTodo(todo) }
                        )
                    }
                }
                .padding(.horizontal, 24)
            }
            
            // Action buttons
            OnboardingActionButtons(
                skipTitle: "Skip this",
                confirmTitle: "Looks good",
                confirmCount: viewModel.activeTodosCount,
                onSkip: { viewModel.skipCurrentStep() },
                onConfirm: { viewModel.confirmCurrentStep() }
            )
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
    }
}

// MARK: - Todo Card

struct TodoCard: View {
    let todo: OnboardingTodo
    let onComplete: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 14) {
            // Todo icon
            ZStack {
                Circle()
                    .fill(todo.isCompleted ? Color.filoSuccess.opacity(0.15) : Color.filoPrimary.opacity(0.1))
                    .frame(width: 36, height: 36)
                
                if todo.isCompleted {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.filoSuccess)
                } else {
                    Image(systemName: "checklist")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.filoPrimary)
                }
            }
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(todo.title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(todo.isCompleted ? .filoTextTertiary : .filoTextPrimary)
                    .strikethrough(todo.isCompleted)
                
                Text("From: \(todo.emailSubject)")
                    .font(.system(size: 12))
                    .foregroundColor(.filoTextTertiary)
            }
            
            Spacer()
            
            // Action buttons
            if !todo.isCompleted {
                HStack(spacing: 8) {
                    // Complete button
                    Button(action: onComplete) {
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.filoSuccess)
                            .frame(width: 36, height: 36)
                            .background(
                                Circle()
                                    .fill(Color.filoSuccess.opacity(0.1))
                            )
                    }
                    
                    // Delete button
                    Button(action: onDelete) {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.filoError)
                            .frame(width: 36, height: 36)
                            .background(
                                Circle()
                                    .fill(Color.filoError.opacity(0.1))
                            )
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.filoSurface)
        )
        .opacity(todo.isCompleted ? 0.6 : 1)
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.filoBackground.ignoresSafeArea()
        OnboardingTodosView(viewModel: OnboardingViewModel())
    }
}
