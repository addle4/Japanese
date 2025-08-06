import SwiftUI

struct Step3_SentenceBuilderView: View {
    var onComplete: () -> Void
    var body: some View {
        VStack(spacing: 20) {
            Text("Step 3: 문장 완성하기").font(.title).fontWeight(.bold).foregroundColor(.white).padding(.top, 30)
            Text("단어를 순서에 맞게 배열하여 문장을 완성하세요.").font(.subheadline).foregroundStyle(.white.opacity(0.7)).multilineTextAlignment(.center)
            Spacer()
            Text("문장 완성 UI 영역").foregroundColor(.gray).frame(height: 250)
            Spacer()
            AppButton(title: "제출하기", action: onComplete)
        }.transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
    }
}
