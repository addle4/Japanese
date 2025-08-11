// LearningFlowView.swift
import SwiftUI

struct LearningFlowView: View {
    @Environment(\.dismiss) var dismiss
    @State private var currentStep: Int = 1
    private let totalSteps: Int = 6

    // ▶️ 모든 Step 에서 공유할 PlayerViewModel
    @StateObject private var viewModel = PlayerViewModel()

    private func advanceToNextStep() {
        withAnimation(.easeInOut(duration: 0.3)) {
            if currentStep < totalSteps {
                currentStep += 1
            } else {
                currentStep = 0 // 완료 화면
            }
        }
    }

    var body: some View {
            VStack(spacing: 0) {
                HStack {
//                    Button(action: { dismiss() }) {
//                        Image(systemName: "xmark")
//                            .font(.headline)
//                            .foregroundColor(.gray)
//                    }
//                    .padding(.leading)

                    ProgressView(value: Double(currentStep), total: Double(totalSteps))
                        .tint(Color(red: 255 / 255, green: 107 / 255, blue: 129 / 255))
                        .scaleEffect(x: 1, y: 2, anchor: .center)
                        .padding(.horizontal)
                }
                .padding(.top)

                switch currentStep {
                case 1:
                    Step1_ListeningView(onComplete: advanceToNextStep, viewModel: viewModel)
                case 2:
                    Step2_DictationView(onComplete: advanceToNextStep, viewModel: viewModel)
                case 3:
                    Step3_SentenceBuilderView(onComplete: advanceToNextStep)
                case 4:
                    Step4_VocabularyView(onComplete: advanceToNextStep, viewModel: viewModel)
                case 5:
                    Step5_CompositionView(onComplete: advanceToNextStep)
                default:
                    CompletionView(
                        onRestart: { withAnimation { currentStep = 1 } },
                        onExit: { dismiss() }
                    )
                }
            }
            .background {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 255/255, green: 220/255, blue: 230/255),
                        .white
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            }
        
    }
}
