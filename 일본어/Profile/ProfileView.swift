import SwiftUI

struct ProfileView: View {
    var body: some View {
        ZStack {
            Color.darkBackground.ignoresSafeArea()
            VStack(spacing: 25) {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)

                Text("사용자 이름")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)

                Text("이메일: example@email.com")
                    .foregroundColor(.white.opacity(0.6))

                Divider().background(.gray)

                VStack(alignment: .leading, spacing: 10) {
                    Text("학습 통계")
                        .font(.headline)
                        .foregroundColor(.accentYellow)

                    Text("· 총 학습일: 17일")
                    Text("· 누적 학습 시간: 5시간 22분")
                    Text("· 단어 암기율: 83%")
                }
                .foregroundColor(.white)

                Spacer()
            }
            .padding()
        }
        .navigationTitle("프로필")
        .navigationBarTitleDisplayMode(.inline)
    }
}
