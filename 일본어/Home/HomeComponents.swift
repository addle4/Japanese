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



