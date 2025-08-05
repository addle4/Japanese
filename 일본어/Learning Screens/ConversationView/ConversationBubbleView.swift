import SwiftUI

struct ConversationBubbleView: View {
    let isUser: Bool
    let japanese: String
    let korean: String
    var furigana: [String]? = nil

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            if !isUser {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.blue)
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(japanese)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 1)
                    )
                    .overlay(
                        // 말풍선 꼬리
                        BubbleTail(isUser: isUser)
                            .offset(x: isUser ? 10 : -10, y: 15), alignment: isUser ? .trailing : .leading
                    )

                Text(korean)
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            if isUser {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.purple)
            }
        }
        .frame(maxWidth: .infinity, alignment: isUser ? .trailing : .leading)
    }
}
