import SwiftUI

// MARK: - Step 2: 받아쓰기 (전면 수정)

// [수정된 부분] Equatable 프로토콜 추가
fileprivate enum QuizState: Equatable {
    case initial // 초기 상태
    case incorrect(revealedAnswer: String) // 오답 상태 (정답 공개)
    case correct // 정답 상태
}

// MARK: - Step 2: 받아쓰기 (클릭 방식)
struct Step2_DictationView: View {
    // 부모 뷰로부터 전달받는 완료 핸들러
    var onComplete: () -> Void
    
    // 퀴즈 데이터 모델 (Equatable 프로토콜 추가)
    struct QuizChoice: Identifiable, Equatable {
        let id = UUID()
        let furigana: String
        let kanji: String
    }
    
    // --- State 변수들 ---
    @State private var quizState: QuizState = .initial
    @State private var selectedChoice: QuizChoice? // 클릭된 선택지를 저장
    
    // 퀴즈 데이터 (첫 번째 항목이 정답)
    private let correctAnswer = "最強"
    private let choices: [QuizChoice] = [
        QuizChoice(furigana: "さいきょう", kanji: "最強"),
        QuizChoice(furigana: "さいしょう", kanji: "最小"),
        QuizChoice(furigana: "さいしょ", kanji: "最初")
    ]
    
    var body: some View {
        ZStack {
            // 밝은 배경색
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 255 / 255, green: 220 / 255, blue: 230 / 255), // #CCBFE0
                    .white
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                HeaderAndVideoView()
                
                // 문제 문장 및 정답 표시 영역
                SentenceAnswerAreaView(quizState: $quizState, selectedChoice: $selectedChoice)
                
                Spacer()
                
                // 클릭할 선택지들
                ChoiceButtonsView(
                    choices: choices,
                    quizState: $quizState,
                    selectedChoice: $selectedChoice,
                    onSelect: handleChoiceSelection
                )
                
                // 하단 버튼
                BottomButtonView(quizState: $quizState, onComplete: onComplete)
            }
            .padding()
        }
        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
    }
    
    // 선택지를 클릭했을 때 호출되는 함수
    private func handleChoiceSelection(choice: QuizChoice) {
        // 이미 정답을 맞췄거나 오답 피드백이 진행 중일 때는 아무것도 하지 않음
        guard case .initial = quizState else { return }
        
        self.selectedChoice = choice
        
        if choice.kanji == correctAnswer {
            // 정답일 경우
            HapticManager.instance.notification(type: .success)
            withAnimation(.spring()) {
                self.quizState = .correct
            }
        } else {
            // 오답일 경우
            HapticManager.instance.notification(type: .error)
            withAnimation(.spring()) {
                self.quizState = .incorrect(revealedAnswer: correctAnswer)
            }
            
            // 1.5초 후 초기 상태로 리셋
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.spring()) {
                    self.quizState = .initial
                    self.selectedChoice = nil
                }
            }
        }
    }
}


// MARK: - Step 2 UI를 구성하는 하위 뷰들

fileprivate struct HeaderAndVideoView: View {
    var body: some View {
        VStack {
            Text("Step 2: 받아쓰기")
                .font(.system(size: 28, weight: .bold))
            
            Text("들리는 대로 빈칸을 채워보세요.")
                .font(.subheadline)
                .foregroundStyle(.gray)
                .padding(.bottom, 10)
            
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(UIColor.systemGray6))
                    .frame(height: 200)
                    .overlay(
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 44))
                            .foregroundColor(.gray.opacity(0.5))
                    )
                
                // ※ "monkey"라는 이름으로 Assets에 이미지 추가 필요
                Image("monkey")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
                    .padding(5)
                    .background(.white)
                    .border(Color.yellow, width: 4)
                    .rotationEffect(.degrees(15))
                    .offset(x: 120, y: -90)
                    .shadow(radius: 5)
            }
            .padding(.horizontal)
        }
    }
}

fileprivate struct SentenceAnswerAreaView: View {
    @Binding var quizState: QuizState
    @Binding var selectedChoice: Step2_DictationView.QuizChoice?
    
    var body: some View {
        HStack(spacing: 10) {
            Text("俺が").font(.title2)
            Text("いれば").font(.title2)
            Text("お前は").font(.title2)
            
            ZStack {
                switch quizState {
                case .initial:
                    if let choice = selectedChoice {
                        // 선택지가 있지만 아직 정답/오답 판별 전
                        ChoiceView(choice: choice)
                    } else {
                        // 완전히 초기 상태 (빈 칸)
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                            .frame(width: 100, height: 50)
                            .foregroundColor(.gray.opacity(0.5))
                    }
                    
                case .incorrect(let revealedAnswer):
                    VStack {
                        Text("틀렸어요!")
                            .font(.caption)
                            .foregroundColor(.red)
                        Text(revealedAnswer)
                            .font(.title2.bold())
                            .foregroundColor(.red)
                    }
                    
                case .correct:
                    VStack {
                        Text("정답!")
                            .font(.caption)
                            .foregroundColor(.blue)
                        if let choice = selectedChoice {
                            ChoiceView(choice: choice, isCorrect: true)
                        }
                    }
                }
            }
            .frame(width: 100, height: 50)
            
            Text("だ！").font(.title2)
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 25)
        .background(Color.yellow.opacity(0.2))
        .cornerRadius(25)
    }
}

fileprivate struct ChoiceButtonsView: View {
    let choices: [Step2_DictationView.QuizChoice]
    @Binding var quizState: QuizState
    @Binding var selectedChoice: Step2_DictationView.QuizChoice?
    let onSelect: (Step2_DictationView.QuizChoice) -> Void
    
    var body: some View {
        HStack(spacing: 15) {
            ForEach(choices) { choice in
                Button(action: {
                    onSelect(choice)
                }) {
                    // isSelected는 현재 버튼이 선택된 버튼인지를 판단
                    let isSelected = (selectedChoice == choice)
                    ChoiceView(choice: choice, isSelected: isSelected, quizState: quizState)
                }
                // [수정된 부분] 이제 이 비교 구문이 정상적으로 동작합니다.
                .disabled(quizState != .initial)
            }
        }
        .padding(.bottom, 20)
    }
}

// 개별 선택지 UI
fileprivate struct ChoiceView: View {
    let choice: Step2_DictationView.QuizChoice
    var isSelected: Bool = false
    var isCorrect: Bool = false // 정답으로 확정되었는지 여부
    var quizState: QuizState? = nil
    
    var body: some View {
        VStack {
            Text(choice.furigana)
                .font(.caption)
            Text(choice.kanji)
                .font(.title3)
                .fontWeight(.bold)
        }
        .padding()
        .frame(minWidth: 100)
        .background(getBackgroundColor())
        .foregroundColor(.black)
        .cornerRadius(15)
        .shadow(color: .yellow.opacity(0.8), radius: isCorrect ? 10 : 0)
    }
    
    // 상태에 따라 배경색을 결정하는 함수
    private func getBackgroundColor() -> Color {
        guard let state = quizState, isSelected else {
            return .yellow.opacity(0.4) // 기본 상태
        }
        
        switch state {
        case .correct:
            return isSelected ? .yellow : .yellow.opacity(0.4) // 정답이면 노란색 강조
        case .incorrect:
            return isSelected ? .red.opacity(0.5) : .yellow.opacity(0.4) // 오답이면 빨간색
        default:
            return .yellow.opacity(0.4)
        }
    }
}

fileprivate struct BottomButtonView: View {
    @Binding var quizState: QuizState
    let onComplete: () -> Void
    
    var body: some View {
        if case .correct = quizState {
            Button(action: onComplete) {
                Text("다음으로!")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentBlue)
                    .foregroundColor(.white)
                    .cornerRadius(15)
            }
            .padding(.horizontal)
            .transition(.opacity.combined(with: .move(edge: .bottom)))
        } else {
            Button(action: {}) { Text("다음으로!") }
                .fontWeight(.bold).frame(maxWidth: .infinity).padding()
                .background(Color.accentBlue).foregroundColor(.white).cornerRadius(15)
                .padding(.horizontal)
                .hidden()
        }
    }
}

// 햅틱 피드백을 쉽게 사용하기 위한 관리자 클래스
fileprivate class HapticManager {
    static let instance = HapticManager()
    private init() {}
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
}
