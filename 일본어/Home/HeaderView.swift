import SwiftUI

// MARK: - 상단 사용자 인사 헤더
struct HeaderView: View {
    let username: String
    let streakCount: Int

    var body: some View {
        HStack {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.gray)

            VStack(alignment: .leading) {
                Text("안녕하세요!")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
                Text("\(username)님")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }

            Spacer()
        }
    }
}

