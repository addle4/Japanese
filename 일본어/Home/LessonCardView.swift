import SwiftUI

// MARK: - 오늘의 장면 학습 카드
struct LessonCardView: View {
    var action: () -> Void

    var body: some View {
        VStack(spacing: 18) {
            HStack {
                Text("오늘의 학습")
                    .font(.subheadline).bold()
                    .foregroundStyle(.black.opacity(0.7))
                Spacer()
            }

            HStack(spacing: 18) {
                // 일러스트/아이콘
                ZStack {
                    Circle()
                        .fill(Color.accentPink.opacity(0.2))
                        .frame(width: 92, height: 92)
                    Image(systemName: "target")
                        .resizable()
                        .scaledToFit()
                        .padding(22)
                        .foregroundStyle(Color.accentPink)
                }

                Spacer()

                // 진행률
                ZStack {
                    Circle()
                        .stroke(Color.black.opacity(0.08), lineWidth: 10)
                        .frame(width: 110, height: 110)
                    Text("0%")
                        .font(.title2).bold()
                        .foregroundStyle(.black.opacity(0.7))
                }
            }

            Button(action: action) {
                HStack(spacing: 8) {
                    Image(systemName: "play.fill")
                    Text("시작하기")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.white)
                .foregroundStyle(Color(red: 232/255, green: 92/255, blue: 116/255)) // 진한 핑크
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.accentPink.opacity(0.25), lineWidth: 1)
                )
            }
            .buttonStyle(.plain)
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.cardBackground)
        )
        .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 6)
    }
}
