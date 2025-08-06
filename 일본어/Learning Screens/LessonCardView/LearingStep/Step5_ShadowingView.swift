import SwiftUI

struct Step5_ShadowingView: View {
    var onComplete: () -> Void
    var body: some View {
        VStack(spacing: 20) {
            Text("Step 5: 따라 말하기").font(.title).fontWeight(.bold).foregroundColor(.white).padding(.top, 30)
            Text("원어민 발음을 듣고 따라 말해보세요.").font(.subheadline).foregroundStyle(.white.opacity(0.7))
            Spacer()
            Image(systemName: "mic.circle.fill").font(.system(size: 80)).foregroundColor(.accentPink)
            Spacer()
            AppButton(title: "녹음 완료!", action: onComplete)
        }.transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
    }
}
