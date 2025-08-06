import SwiftUI

struct Step5_CompositionView: View {
    var onComplete: () -> Void
    var body: some View {
        VStack(spacing: 20) {
            Text("Step 6: 응용 작문").font(.title).fontWeight(.bold).foregroundColor(.white).padding(.top, 30)
            Text("배운 표현을 사용해 문장을 만들어보세요.").font(.subheadline).foregroundStyle(.white.opacity(0.7))
            Spacer()
            Text("작문 UI 영역").foregroundColor(.gray).frame(height: 250)
            Spacer()
            AppButton(title: "학습 완료!", backgroundColor: Color(red: 255 / 255, green: 107 / 255, blue: 129 / 255), action: onComplete)
        }.transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
    }
}
