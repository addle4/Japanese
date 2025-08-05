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

            HStack(spacing: 5) {
                Image(systemName: "flame.fill")
                    .foregroundColor(.accentPink)
                Text("\(streakCount)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.black.opacity(0.3))
            .cornerRadius(20)
        }
    }
}

// MARK: - 오늘의 장면 학습 카드
struct LessonCardView: View {
    var action: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("📚✏️")
                    .font(.system(size: 60))
                Spacer()
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.5), lineWidth: 6)
                        .frame(width: 70, height: 70)
                    Text("0%")
                        .font(.headline)
                        .foregroundColor(Color(hex: "#6932BE"))
                }
            }

            Button(action: action) {
                HStack {
                    Image(systemName: "play.fill")
                    Text("시작하기")
                        .fontWeight(.bold)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 30)
                .padding(.vertical, 12)
                .background(Color(hex: "#BCA3FF"))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.2), radius: 3, x: 1, y: 2)
            }
        }
        .padding()
        .background(Color(hex: "#E9DAFF"))
        .cornerRadius(25)
    }
}

// MARK: - 히라가나 / 가타카나 섹션
struct KanaSectionView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            let hiraganaGridData = KanaDataProvider.getData(for: .hiragana)
            let katakanaGridData = KanaDataProvider.getData(for: .katakana)
            Text("기초 다지기")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.white)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    NavigationLink(destination: KanaTableView(title: "히라가나", gridData: hiraganaGridData)) {
                        KanaCardView(title: "히라가나", subtitle: "기본 문자 익히기", iconName: "a.square.fill")
                    }
                    NavigationLink(destination: KanaTableView(title: "가타카나", gridData: katakanaGridData)) {
                        KanaCardView(title: "가타카나", subtitle: "외래어 표기 익히기", iconName: "k.square.fill")
                    }
                }
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - 개별 카드 (히라가나, 가타카나 진입)
struct KanaCardView: View {
    let title: String
    let subtitle: String
    let iconName: String

    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: iconName)
                .font(.title)
                .foregroundColor(.accentBlue)

            Spacer()

            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(.white)

            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.7))
        }
        .padding()
        .frame(width: 150, height: 120, alignment: .leading)
        .background(Color.cardBackground)
        .cornerRadius(15)
        .contentShape(Rectangle()) // ✅
    }
}

// MARK: - 공통 버튼
struct AppButton: View {
    let title: String
    var backgroundColor: Color = .accentBlue
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(backgroundColor)
                .foregroundColor(.white)
                .cornerRadius(15)
        }
        .padding(.horizontal)
        .padding(.bottom, 10)
    }
}

// MARK: - 오늘의 회화 카드
struct ConversationCardView: View {
    var action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("오늘은 기분이 좋아요")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "#6932BE"))

            // ✅ 일본어 문장에 검정 테두리 추가
            Text("今日は 気分が いいです。")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .overlay( // 윤곽선 추가
                    Text("今日は 気分が いいです。")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .blur(radius: 0.1)
                )
                .padding(.bottom, 5)

            // ✅ 일본어 문장의 시작에 맞춰 정렬
            HStack {
                Button(action: action) {
                    HStack {
                        Image(systemName: "play.fill")
                        Text("학습하기")
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.white)
                    .foregroundColor(Color(hex: "#6932BE"))
                    .clipShape(Capsule())
                }

                Spacer() // 오른쪽 공간 확보용
            }
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "#D2B4FF"), Color(hex: "#EAD6FF")]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .cornerRadius(20)
    }
}
// MARK: - Hex 컬러 초기화
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255

        self.init(red: r, green: g, blue: b)
    }
}

