import SwiftUI

// MARK: - Step 2 상태 정의
enum QuizState: Equatable {
    case initial
    case incorrect(revealedAnswer: String)
    case correct
    case finishedWrongAnswer
}

// MARK: - Step 2 받아쓰기 뷰
struct Step2_DictationView: View {
    var onComplete: () -> Void

    struct QuizChoice: Identifiable, Equatable {
        let id = UUID()
        let furigana: String
        let kanji: String
    }

    @State private var quizState: QuizState = .initial
    @State private var selectedChoice: QuizChoice?

    private let correctAnswer = "最強"
    private let choices: [QuizChoice] = [
        QuizChoice(furigana: "さいきょう", kanji: "最強"),
        QuizChoice(furigana: "さいしょう", kanji: "最小"),
        QuizChoice(furigana: "さいしょ", kanji: "最初")
    ]

    var body: some View {
        VStack(spacing: 20) {
            HeaderAndVideoView()
                .padding(.top, 20)

            Spacer()

            // ✅ 문장카드 (항상 분홍 말풍선 + 점선 빈칸)
            SentenceAnswerAreaView(quizState: $quizState, selectedChoice: $selectedChoice)

            Spacer().frame(height: 10)

            // ✅ 낱말카드 (분홍 칩, 위 후리가나 / 아래 한자)
            ChoiceButtonsView(
                choices: choices,
                quizState: $quizState,
                selectedChoice: $selectedChoice,
                onSelect: handleChoiceSelection
            )

            Spacer()

            BottomButtonView(quizState: $quizState, onComplete: onComplete)
        }
        .padding(.horizontal, 24)
    }

    private func handleChoiceSelection(choice: QuizChoice) {
        guard case .initial = quizState else { return }
        selectedChoice = choice

        if choice.kanji == correctAnswer {
            HapticManager.instance.notification(type: .success)
            withAnimation(.spring()) { quizState = .correct }
        } else {
            HapticManager.instance.notification(type: .error)
            withAnimation(.spring()) {
                quizState = .incorrect(revealedAnswer: correctAnswer)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.spring()) { quizState = .finishedWrongAnswer }
            }
        }
    }
}

fileprivate struct HeaderAndVideoView: View {
    var body: some View {
        VStack(spacing: 11) {
            Text("Step 2 : 빈칸 채우기")
                .font(.system(size: 24, weight: .bold))
                .padding(.top, 30)

            Text("들리는 대로 빈칸을 채워보세요")
                .font(.subheadline)
                .foregroundColor(.gray)

            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(UIColor.systemGray6))
                    .frame(height: 180)
                    .overlay(
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.gray.opacity(0.5))
                    )
            }
        }
    }
}

// MARK: - ✅ 문장카드 (디자인 변경)
fileprivate struct SentenceAnswerAreaView: View {
    @Binding var quizState: QuizState
    @Binding var selectedChoice: Step2_DictationView.QuizChoice?

    var body: some View {
        HStack(spacing: 10) {
            Text("俺が いれば お前は")
                .font(.system(size: 20, weight: .regular))

            // 이미지처럼: 항상 점선 빈칸 (정답/오답과 무관)
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    Color(red: 0.77, green: 0.77, blue: 0.77),
                    style: StrokeStyle(lineWidth: 1, dash: [6])
                )
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                .frame(width: 110, height: 36)

            Text("だ！")
                .font(.system(size: 20, weight: .regular))
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 16)
        .background(Color(red: 1.0, green: 0.86, blue: 0.86)) // 연분홍 말풍선
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color(red: 0.77, green: 0.77, blue: 0.77), lineWidth: 1)
        )
        .cornerRadius(22)
        .foregroundColor(.black)
    }
}

// MARK: - ✅ 낱말 버튼 행 (디자인 변경)
fileprivate struct ChoiceButtonsView: View {
    let choices: [Step2_DictationView.QuizChoice]
    @Binding var quizState: QuizState
    @Binding var selectedChoice: Step2_DictationView.QuizChoice?
    let onSelect: (Step2_DictationView.QuizChoice) -> Void

    var body: some View {
        HStack(spacing: 18) {
            ForEach(choices) { choice in
                Button {
                    onSelect(choice)
                } label: {
                    ChoiceView(
                        choice: choice,
                        isSelected: selectedChoice == choice,
                        quizState: quizState
                    )
                }
                .disabled(quizState != .initial)
            }
        }
    }
}

// MARK: - ✅ 낱말칩 (디자인 변경)
fileprivate struct ChoiceView: View {
    let choice: Step2_DictationView.QuizChoice
    var isSelected: Bool = false
    var isCorrect: Bool = false
    var quizState: QuizState? = nil

    var body: some View {
        VStack(spacing: 4) {
            Text(choice.furigana)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.black.opacity(0.75))

            Text(choice.kanji)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 14)
        .background(backgroundColor)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(red: 0.77, green: 0.77, blue: 0.77), lineWidth: 1)
        )
        .cornerRadius(14)
        .scaleEffect(isSelected ? 0.98 : 1.0)
        .animation(.spring(response: 0.25, dampingFraction: 0.85), value: isSelected)
    }

    private var backgroundColor: Color {
        // 기본은 연분홍, 선택 후 정답/오답이면 약한 피드백
        guard let state = quizState, isSelected else {
            return Color(red: 1.0, green: 0.86, blue: 0.86)
        }
        switch state {
        case .correct:
            return Color.green.opacity(0.25)
        case .incorrect:
            return Color.red.opacity(0.25)
        default:
            return Color(red: 1.0, green: 0.86, blue: 0.86)
        }
    }
}

fileprivate struct BottomButtonView: View {
    @Binding var quizState: QuizState
    let onComplete: () -> Void

    var body: some View {
        if quizState == .correct || quizState == .finishedWrongAnswer {
            Button(action: onComplete) {
                Text("다음으로!")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentPink) // 프로젝트 확장 컬러 사용
                    .foregroundColor(.white)
                    .cornerRadius(15)
            }
            .padding(.horizontal)
            .transition(.opacity.combined(with: .move(edge: .bottom)))
        } else {
            Button(action: {}) { Text("다음으로!") }.hidden()
        }
    }
}

fileprivate class HapticManager {
    static let instance = HapticManager()
    private init() {}

    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
}
 
