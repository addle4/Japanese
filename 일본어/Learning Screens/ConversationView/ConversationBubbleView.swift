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
                HStack(alignment: .center, spacing: 5) {
                    Text(japanese)
                        .foregroundColor(.black)

                    Button(action: {
                        speak(japanese)
                    }) {
                        Image(systemName: "speaker.wave.2.fill")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(
                    ZStack(alignment: isUser ? .bottomTrailing : .bottomLeading) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)

                        BubbleTail(isUser: isUser)
                            .offset(x: isUser ? 6 : -6, y: 6)
                    }
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 1)
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
