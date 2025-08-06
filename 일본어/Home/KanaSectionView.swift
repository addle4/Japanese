import SwiftUI

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
