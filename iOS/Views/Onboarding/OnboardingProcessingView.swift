//
//  OnboardingProcessingView.swift
//  Filo
//
//  Step 0: AI Processing animation
//  Jira: FILO-1616
//

import SwiftUI

struct OnboardingProcessingView: View {
    @Bindable var viewModel: OnboardingViewModel
    
    var body: some View {
        VStack(spacing: 32) {
            // Processing animation
            ProcessingAnimation()
                .frame(width: 120, height: 120)
            
            // Task list
            VStack(alignment: .leading, spacing: 16) {
                ForEach(Array(viewModel.processingTasks.enumerated()), id: \.element.id) { index, task in
                    ProcessingTaskRow(
                        task: task,
                        isActive: index == viewModel.currentProcessingIndex,
                        isVisible: index <= viewModel.currentProcessingIndex
                    )
                }
            }
            .padding(.horizontal, 40)
        }
        .padding(.horizontal, 24)
    }
}

// MARK: - Processing Animation

struct ProcessingAnimation: View {
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 1
    
    var body: some View {
        ZStack {
            // Outer ring
            Circle()
                .stroke(Color.filoPrimary.opacity(0.2), lineWidth: 4)
            
            // Animated arc
            Circle()
                .trim(from: 0, to: 0.3)
                .stroke(
                    Color.filoPrimary,
                    style: StrokeStyle(lineWidth: 4, lineCap: .round)
                )
                .rotationEffect(.degrees(rotation))
            
            // Inner sparkle
            SparkleIconWhite()
                .frame(width: 32, height: 32)
                .foregroundColor(.filoPrimary)
                .scaleEffect(scale)
        }
        .onAppear {
            withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                rotation = 360
            }
            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                scale = 1.1
            }
        }
    }
}

// MARK: - Processing Task Row

struct ProcessingTaskRow: View {
    let task: ProcessingTask
    let isActive: Bool
    let isVisible: Bool
    
    @State private var appeared = false
    
    var body: some View {
        HStack(spacing: 12) {
            // Status indicator
            ZStack {
                if task.isComplete {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.filoSuccess)
                } else if isActive {
                    ProgressView()
                        .scaleEffect(0.8)
                        .tint(.filoPrimary)
                } else {
                    Circle()
                        .stroke(Color.filoTextTertiary, lineWidth: 1.5)
                        .frame(width: 20, height: 20)
                }
            }
            .frame(width: 24, height: 24)
            
            // Task message
            Text(task.message)
                .font(.system(size: 15))
                .foregroundColor(task.isComplete ? .filoTextSecondary : (isActive ? .filoTextPrimary : .filoTextTertiary))
        }
        .opacity(isVisible ? (appeared ? 1 : 0) : 0)
        .offset(y: isVisible ? (appeared ? 0 : 10) : 10)
        .onChange(of: isVisible) { _, visible in
            if visible {
                withAnimation(.easeOut(duration: 0.3)) {
                    appeared = true
                }
            }
        }
        .onAppear {
            if isVisible {
                withAnimation(.easeOut(duration: 0.3)) {
                    appeared = true
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.filoBackground.ignoresSafeArea()
        OnboardingProcessingView(viewModel: OnboardingViewModel())
    }
}
