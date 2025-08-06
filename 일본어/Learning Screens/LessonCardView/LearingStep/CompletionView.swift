import SwiftUI

struct CompletionView: View {
    var onRestart: () -> Void, onExit: () -> Void
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "checkmark.circle.fill").font(.system(size: 80)).foregroundColor(.green)
            Text("학습 완료!").font(.largeTitle).fontWeight(.bold).foregroundColor(.white)
            Text("오늘의 장면 학습을 모두 마쳤습니다.").foregroundStyle(.white.opacity(0.7))
            Spacer()
            VStack(spacing: 15) {
                AppButton(title: "처음으로 돌아가기", backgroundColor: .accentBlue, action: onRestart)
                AppButton(title: "메인으로 돌아가기", backgroundColor: .cardBackground, action: onExit)
            }
        }.transition(.opacity)
    }
}
