import SwiftUI

struct Step4_VocabularyView: View {
    var onComplete: () -> Void
    var body: some View {
        VStack(spacing: 20) {
            Text("Step 4: 어휘/문법 학습").font(.title).fontWeight(.bold).foregroundColor(.white).padding(.top, 30)
            Text("장면에 나온 주요 표현이에요!").font(.subheadline).foregroundStyle(.white.opacity(0.7))
            Spacer()
            Text("어휘/문법 UI 영역").foregroundColor(.gray).frame(height: 250)
            Spacer()
            AppButton(title: "모두 학습했어요", action: onComplete)
        }.transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
    }
}
