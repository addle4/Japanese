import SwiftUI

struct HeaderView: View {
    let username: String
    let streakCount: Int

    var body: some View {
        HStack {
            // 프로필 이미지
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.gray)

            // 텍스트 정보
            VStack(alignment: .leading, spacing: 2) {
                Text("이쿠죠 \(streakCount)일차")
                    .font(.caption)
                    .foregroundColor(.black)
                Text(username)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }

            Spacer()

            // 환율 정보
            HStack(spacing: 4) {
                Circle()
                    .fill(Color.red)
                    .frame(width: 8, height: 8)
                Text("JPY 100 = 934.79원")
                    .font(.caption)
                    .foregroundColor(.black)
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
}
