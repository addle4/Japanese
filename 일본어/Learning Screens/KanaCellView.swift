import SwiftUI

struct KanaCellView: View {
    let character: KanaCharacter

    var body: some View {
        VStack(spacing: 5) {
            Text(character.kana)
                .font(.system(size: 36))
                .foregroundColor(.white)
            Text(character.pronunciation)
                .font(.footnote)
                .fontWeight(.medium)
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .frame(height: 80)
        .background(Color.cardBackground)
        .cornerRadius(10)
        .drawingGroup() // GPU 렌더링
    }
}

