import SwiftUI

struct ConversationView: View {
    @State private var visibleMessages: [ConversationMessage] = []
    @State private var showButton = false

    private let allMessages: [ConversationMessage] = [
        ConversationMessage(
            id: 1,
            japanese: "こんにちは",
            korean: "안녕하세요",
            isUser: false,
            furigana: [
                FuriganaUnit(text: "こん", furigana: nil),
                FuriganaUnit(text: "にち", furigana: nil),
                FuriganaUnit(text: "は", furigana: nil)
            ]
        ),
        ConversationMessage(
            id: 2,
            japanese: "こんにちは",
            korean: "안녕하세요",
            isUser: true,
            furigana: [
                FuriganaUnit(text: "こん", furigana: nil),
                FuriganaUnit(text: "にち", furigana: nil),
                FuriganaUnit(text: "は", furigana: nil)
            ]
        ),
        ConversationMessage(
            id: 3,
            japanese: "今日の 気分は どうですか。",
            korean: "오늘의 기분은 어떤가요?",
            isUser: false,
            furigana: [
                FuriganaUnit(text: "今日", furigana: "きょう"),
                FuriganaUnit(text: "の", furigana: nil),
                FuriganaUnit(text: "気分", furigana: "きぶん"),
                FuriganaUnit(text: "は", furigana: nil),
                FuriganaUnit(text: "どう", furigana: nil),
                FuriganaUnit(text: "です", furigana: nil),
                FuriganaUnit(text: "か", furigana: nil)
            ]
        ),
        ConversationMessage(
            id: 4,
            japanese: "今日は 気分が いいです。",
            korean: "오늘은 기분이 좋아요.",
            isUser: true,
            furigana: [
                FuriganaUnit(text: "今日", furigana: "きょう"),
                FuriganaUnit(text: "は", furigana: nil),
                FuriganaUnit(text: "気分", furigana: "きぶん"),
                FuriganaUnit(text: "が", furigana: nil),
                FuriganaUnit(text: "いい", furigana: nil),
                FuriganaUnit(text: "です", furigana: nil)
            ]
        )
    ]

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 255 / 255, green: 220 / 255, blue: 230 / 255),
                    .white
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Text("오늘의 회화")
                    .font(.system(size: 24, weight: .bold))
                    .padding(.top, 30)

                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(visibleMessages, id: \.id) { message in
                            MessageBubble(message: message) {
                                // 음성 재생 기능
                            }
                        }
                        Spacer(minLength: 80) // 버튼과 겹치지 않게
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                }

                Spacer().frame(height: 80)
            }

            if showButton {
                VStack {
                    Spacer()
                    Button(action: {
                        // 핵심단어 보러가기 액션
                    }) {
                        Text("핵심단어 보러가기")
                            .foregroundColor(Color(red: 255/255, green: 107/255, blue: 129/255))
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(red: 255/255, green: 107/255, blue: 129/255), lineWidth: 2)
                            )
                    }
                    .padding(.bottom, 20)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .onAppear {
            showMessagesSequentially()
        }
    }

    private func showMessagesSequentially() {
        for (index, message) in allMessages.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 1.2) {
                withAnimation {
                    visibleMessages.append(message)

                    if index == allMessages.count - 1 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            withAnimation {
                                showButton = true
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - 말풍선 View
struct MessageBubble: View {
    let message: ConversationMessage
    let onPlay: () -> Void

    var body: some View {
        HStack {
            if message.isUser { Spacer() }

            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 6) {
                FuriganaTextView(units: message.furigana)
                    .padding(10)
                    .background(message.isUser ? Color.white : Color(red: 243/255, green: 244/255, blue: 248/255))
                    .cornerRadius(15)
                    .frame(maxWidth: .infinity, alignment: message.isUser ? .trailing : .leading)

                HStack(spacing: 4) {
                    Button(action: onPlay) {
                        Image(systemName: "speaker.wave.2.fill")
                            .foregroundColor(.gray)
                    }
                    Text(message.korean)
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }

            if !message.isUser { Spacer() }
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: message.isUser ? .trailing : .leading)
    }
}
