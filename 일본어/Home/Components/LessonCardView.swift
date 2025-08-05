import SwiftUI

// MARK: - 오늘의 장면 학습 카드
struct LessonCardView: View {
    var action: () -> Void

    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Text("오늘의 학습")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                Spacer()
            }

            Image(systemName: "film.fill")
                .font(.system(size: 50))
                .foregroundColor(.accentPink)

            Text("새로운 장면으로 일본어를 배워봐요!")
                .foregroundStyle(.white.opacity(0.8))

            AppButton(title: "학습 시작하기", action: action)
        }
        .padding()
        .background(Color.cardBackground)
        .cornerRadius(20)
    }
}
