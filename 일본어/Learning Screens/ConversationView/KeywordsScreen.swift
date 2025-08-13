import SwiftUI

struct KeywordsScreen: View {
    @Environment(\.dismiss) private var dismiss

    @State private var keywords: [VocabItem] = [
        VocabItem(kanji: "気分",  furigana: "きぶん", korean: "기분", dayTag: "Day1"),
        VocabItem(kanji: "今日",  furigana: "きょう", korean: "오늘", dayTag: "Day1"),
        VocabItem(kanji: "何か",  furigana: "なんか", korean: "몇 번", dayTag: "Day1"),
        VocabItem(kanji: "たぶん", furigana: nil,     korean: "아마",  dayTag: "Day1"),
        VocabItem(kanji: "月",    furigana: "げつ",   korean: "월",    dayTag: "Day1")
    ]
    @State private var localOn: Set<UUID> = []

    var body: some View {
        VStack(spacing: 12) {
            Text("오늘의 핵심 단어")
                .font(.system(size: 24, weight: .bold))

            List {
                ForEach(keywords) { item in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            if let f = item.furigana, !f.isEmpty {
                                Text(f).font(.caption).foregroundColor(.gray)
                            }
                            Text(item.kanji).font(.headline)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 4) {
                            Text(item.korean).font(.subheadline)
                            Button {
                                let willOn = !localOn.contains(item.id)
                                if willOn { localOn.insert(item.id) } else { localOn.remove(item.id) }

                                NotificationCenter.default.post(
                                    name: AppNotification.vocabBookmarkChanged,
                                    object: nil,
                                    userInfo: [
                                        "hiragana": item.furigana ?? "",
                                        "kanji": item.kanji,
                                        "meaning": item.korean,
                                        "day": item.dayTag ?? "Day1",
                                        "isOn": willOn,
                                        "source": "keywords" // 회화 탭으로 저장
                                    ]
                                )
                            } label: {
                                Image(systemName: localOn.contains(item.id) ? "bookmark.fill" : "bookmark")
                                    .font(.title3)
                                    .foregroundColor(Color(red: 1.0, green: 0.42, blue: 0.51))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 6)
                }
            }
            .listStyle(.plain)

            Button(action: {
                saveSelectionsToConversation()
                dismiss() // ← 시트만 닫기 (그 다음은 부모가 처리)
            }) {
                Text("학습완료")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 1.0, green: 0.42, blue: 0.51))
                    .foregroundColor(.white)
                    .cornerRadius(14)
            }
            .padding(.horizontal)
        }
        .padding(.top, 8)
        .onAppear {
            let saved = VocabularyStorage.shared.loadConversation()
            let ids = keywords
                .filter { k in saved.contains { $0.kanji == k.kanji && $0.korean == k.korean } }
                .map(\.id)
            localOn = Set(ids)
        }
    }

    private func saveSelectionsToConversation() {
        let selectedItems = keywords.filter { localOn.contains($0.id) }
        guard !selectedItems.isEmpty else { return }

        var current = VocabularyStorage.shared.loadConversation()
        for item in selectedItems {
            if !current.contains(where: { $0.kanji == item.kanji && $0.korean == item.korean }) {
                current.insert(item, at: 0)
            }
        }
        VocabularyStorage.shared.saveConversation(current)

        // 단어장 실시간 갱신
        for item in selectedItems {
            NotificationCenter.default.post(
                name: AppNotification.vocabBookmarkChanged,
                object: nil,
                userInfo: [
                    "hiragana": item.furigana ?? "",
                    "kanji": item.kanji,
                    "meaning": item.korean,
                    "day": item.dayTag ?? "Day1",
                    "isOn": true,
                    "source": "keywords"
                ]
            )
        }
    }
}
