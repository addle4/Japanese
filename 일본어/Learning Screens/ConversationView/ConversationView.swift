import SwiftUI

struct ConversationView: View{
    var body: some View{
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 204 / 255, green: 191 / 255, blue: 224 / 255), // #CCBFE0
                    .white
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(alignment: .leading,spacing: 20){
                HStack(spacing: 10) {
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                        .foregroundColor(.purple)
                    Text("오늘의 회화")
                        .font(.title)
                        .fontWeight(.bold)
                }
                .padding(.top, 30)
                .padding(.horizontal)
                
                ScrollView{
                    VStack(spacing: 15){
                        ConversationBubbleView(
                            isUser: false,
                            japanese: "こんにちは",
                            korean: "안녕하세요"
                        )
                        
                        ConversationBubbleView(
                            isUser: true,
                            japanese: "こんにちは",
                            korean: "안녕하세요"
                        )
                        
                        ConversationBubbleView(
                            isUser: false,
                            japanese: "今日の 気分は どうですか。",
                            korean: "오늘의 기분은 어떤가요?",
                            furigana: ["きょう", "きぶん"]
                        )
                        
                        ConversationBubbleView(
                            isUser: true,
                            japanese: "今日は 気分が いいです。",
                            korean: "오늘은 기분이 좋아요.",
                            furigana: ["きょう", "きぶん"]
                        )
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
                
                // 하단 버튼
                HStack {
                    Spacer()
                    Button(action: {
                        // 핵심단어 보기 액션
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: "play.fill")
                            Text("핵심단어 보러가기")
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .fontWeight(.bold)
                        .background(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 1))
                    }
                    .foregroundColor(.purple)
                    .padding()
                }
            }
        }
    }
}
