import SwiftUI

struct Step3_SentenceBuilderView: View {
    var onComplete: () -> Void
    
    // ✅ 초기 단어 목록 따로 저장
    private let originalWords: [String] = [
        "안", "녕", "하하하", "하", "하", "하", "하", "하", "하", "하", "하", "세", "요"
    ]
    
    @State private var selectedWords: [String] = []
    @State private var availableWords: [String] = []
    @State private var hasSubmitted = false
    @State private var highlightColor: Color? = nil
    @State private var shakeOffset: CGFloat = 0
    @State private var showResultView = false
    @State private var resultType: ResultType? = nil
    @State private var draggedItem: String? = nil

    let correctSentence = [
        "안", "녕", "하하하", "하", "하", "하", "하", "하", "하", "하", "하", "세", "요"
    ]
    
    enum ResultType {
        case correct
        case wrong
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Text("Step 3: 문장 완성하기")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 30)
                
                Text("단어를 순서에 맞게 배열하여 문장을 완성하세요.")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                // 선택된 단어 영역
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 70), spacing: 6)], spacing: 6) {
                    ForEach(selectedWords.indices, id: \.self) { index in
                        let word = selectedWords[index]
                        Text(word)
                            .font(.system(size: 18, weight: .medium))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(highlightColor ?? Color.white)
                            .cornerRadius(8)
                            .onDrag {
                                draggedItem = word
                                return NSItemProvider(object: word as NSString)
                            }
                            .onDrop(of: [.text], delegate: WordDropDelegate(
                                currentItem: word,
                                items: $selectedWords,
                                draggedItem: $draggedItem
                            ))
                    }
                }
                .offset(x: shakeOffset)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white.opacity(0.3))
                .cornerRadius(8)
                .padding()
                .animation(.easeInOut, value: selectedWords)
                .animation(.easeInOut, value: highlightColor)
                
                // 선택 가능한 단어 버튼
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 70), spacing: 6)], spacing: 6) {
                    ForEach(availableWords.indices, id: \.self) { index in
                        let word = availableWords[index]
                        Button(action: {
                            selectedWords.append(word)
                            availableWords.remove(at: index)
                        }) {
                            Text(word)
                                .font(.system(size: 18, weight: .medium))
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(Color(red: 255/255, green: 229/255, blue: 153/255))
                                .cornerRadius(8)
                        }
                    }
                }
                .padding()
                
                // 컨트롤 버튼
                HStack {
                    Button("다시 하기") {
                        resetSentence()
                    }
                    .disabled(hasSubmitted)
                    .padding()
                    .background(Color.gray.opacity(0.6))
                    .cornerRadius(8)
                    .foregroundColor(.white)
                }
                
                // 제출 버튼
                AppButton(title: "제출하기", action: {
                    checkAnswer()
                })
            }
            .onAppear {
                resetSentence()
            }
            .transition(.asymmetric(insertion: .move(edge: .trailing),
                                    removal: .move(edge: .leading)))
            
            // 하단 팝업
            if showResultView {
                VStack {
                    Spacer()
                    VStack(spacing: 16) {
                        HStack(spacing: 8) {
                            Circle()
                                .fill(resultType == .wrong ? Color.red : Color.green)
                                .frame(width: 24, height: 24)
                                .overlay(
                                    Image(systemName: resultType == .wrong ? "xmark" : "checkmark")
                                        .foregroundColor(.white)
                                        .font(.system(size: 14, weight: .bold))
                                )
                            Text(resultType == .wrong ? "오답입니다" : "정답입니다")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(resultType == .wrong ? Color.red : Color.green)
                            Spacer()
                        }
                        
                        if resultType == .wrong {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("정답:")
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                LazyVGrid(columns: [GridItem(.adaptive(minimum: 70), spacing: 6)], spacing: 6) {
                                    ForEach(correctSentence.indices, id: \.self) { idx in
                                        let word = correctSentence[idx]
                                        Text(word)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .background(Color.white)
                                            .cornerRadius(8)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(Color.red, lineWidth: 2)
                                            )
                                    }
                                }
                            }
                        }
                        
                        Button(action: {
                            withAnimation(.interpolatingSpring(stiffness: 200, damping: 10)) {
                                showResultView = false
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                onComplete()
                            }
                        }) {
                            Text(resultType == .wrong ? "확인" : "계속 학습하기")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(resultType == .wrong ? Color.red : Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 2)
                        }
                        .contentShape(Rectangle())
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray5))
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .padding(.horizontal, 16)
                    .transition(.move(edge: .bottom))
                }
                .edgesIgnoringSafeArea(.bottom)
            }
        }
        .animation(.spring(), value: showResultView)
    }
    
    func checkAnswer() {
        hasSubmitted = true
        guard !selectedWords.isEmpty else {
            highlightColor = .red
            showShake()
            resultType = .wrong
            withAnimation(.spring()) { showResultView = true }
            return
        }
        
        if selectedWords == correctSentence {
            highlightColor = .green
            resultType = .correct
        } else {
            highlightColor = .red
            showShake()
            resultType = .wrong
        }
        withAnimation(.spring()) { showResultView = true }
    }
    
    func showShake() {
        withAnimation(.default.repeatCount(3, autoreverses: true)) {
            shakeOffset = 10
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            shakeOffset = 0
        }
    }
    
    func resetSentence() {
        selectedWords.removeAll()
        availableWords = originalWords.shuffled()
        hasSubmitted = false
        highlightColor = nil
        shakeOffset = 0
    }
}

// 드래그 앤 드롭 순서 변경용 DropDelegate
struct WordDropDelegate: DropDelegate {
    let currentItem: String
    @Binding var items: [String]
    @Binding var draggedItem: String?
    
    func dropEntered(info: DropInfo) {
        guard let draggedItem = draggedItem,
              draggedItem != currentItem,
              let fromIndex = items.firstIndex(of: draggedItem),
              let toIndex = items.firstIndex(of: currentItem) else { return }
        
        withAnimation {
            items.move(fromOffsets: IndexSet(integer: fromIndex),
                       toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex)
        }
    }
    
    func performDrop(info: DropInfo) -> Bool {
        draggedItem = nil
        return true
    }
}

struct Step3_SentenceBuilderView_Previews: PreviewProvider {
    static var previews: some View {
        Step3_SentenceBuilderView(onComplete: {})
            .previewDisplayName("Step 3: 문장 완성하기")
    }
}
