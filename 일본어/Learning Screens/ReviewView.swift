import SwiftUI

struct ReviewView: View {
    var body: some View {
        ZStack {
            Color.darkBackground.ignoresSafeArea()
            VStack(spacing: 20) {
                Text("복습 모드")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text("기억이 희미해진 단어와 표현들을 복습해요.")
                    .foregroundColor(.white.opacity(0.7))

                Spacer()

                VStack(spacing: 10) {
                    Text("오늘 복습할 항목이 5개 있어요!")
                        .foregroundColor(.accentYellow)

                    Button("복습 시작") {
                        // 복습 모드 진입
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accentBlue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("복습")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ReviewView()
}
