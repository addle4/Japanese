import SwiftUI

// MARK: - Step 1: 몰입해서 듣기
struct Step1_ListeningView: View {
    var onComplete: () -> Void
    var body: some View {
        VStack(spacing: 20) {
            Text("Step 1: 몰입해서 듣기").font(.title).fontWeight(.bold).foregroundColor(.white).padding(.top, 30)
            Text("자막 없이 장면에 집중하며 들어보세요.").font(.subheadline).foregroundStyle(.white.opacity(0.7))
            Spacer()
            Rectangle().fill(Color.black.opacity(0.2)).overlay(Image(systemName: "play.circle.fill").font(.system(size: 44)).foregroundColor(.white.opacity(0.5))).frame(height: 250).cornerRadius(20).padding(.horizontal)
            Spacer()
            AppButton(title: "내용 파악 완료! 다음으로", action: onComplete)
        }.transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
    }
}
