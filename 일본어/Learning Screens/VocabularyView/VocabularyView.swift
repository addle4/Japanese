import SwiftUI

struct Word: Identifiable, Equatable {
    let id = UUID()
    let hiragana: String
    let kanji: String
    let meaning: String
    let day: String
    var isSelected: Bool = false
}

struct VocabularyView: View {
    enum TabType {
        case learning
        case conversation
    }

    @State private var selectedTab: TabType = .learning
    @State private var isAllSelected: Bool = false

    @State private var learningWords: [Word] = [
        
    ]

    @State private var conversationWords: [Word] = [
        Word(hiragana: "きぶん", kanji: "気分", meaning: "기분", day: "Day1"),
        Word(hiragana: "きょう", kanji: "今日", meaning: "오늘", day: "Day1"),
        Word(hiragana: "いい", kanji: "いい", meaning: "좋다", day: "Day1"),
        Word(hiragana: "どう", kanji: "どう", meaning: "어떤가", day: "Day1")
    ]

    var body: some View {
        VStack(spacing: 0) {
            // 상단 제목
            ZStack {
                Text("나만의 단어장")
                    .bold()
                    .font(.title)
                    .padding()
            }
            .frame(maxWidth: .infinity)
            .background(Color.pink.opacity(0.2))

            HStack {
                Spacer()
                HStack(spacing: 0) {
                    Button(action: { selectedTab = .learning }) {
                        Text("오늘의 학습")
                            .font(.system(size: 14))
                            .fontWeight(selectedTab == .learning ? .bold : .regular)
                            .frame(width: 100, height: 20)
                            .background(selectedTab == .learning ? Color.white : Color.clear)
                            .cornerRadius(5)
                            .foregroundColor(.black)
                    }

                    Button(action: { selectedTab = .conversation }) {
                        Text("오늘의 회화")
                            .font(.system(size: 14))
                            .fontWeight(selectedTab == .conversation ? .bold : .regular)
                            .frame(width: 100, height: 20)
                            .background(selectedTab == .conversation ? Color.white : Color.clear)
                            .cornerRadius(5)
                            .foregroundColor(.black)
                    }
                }
                .padding(3)
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
                Spacer()
            }
            .padding(.top, 10)

            HStack {
                Button(action: {
                    deleteSelectedWords()
                }) {
                    ZStack {
                        Circle()
                            .fill(Color(red: 1.0, green: 0.42, blue: 0.51)) // #FF6B81
                            .frame(width: 36, height: 36)
                        Image(systemName: "trash.fill")
                            .foregroundColor(.white)
                    }
                }

                Spacer()
                Button(action: {
                    isAllSelected.toggle()
                    selectAllWords(isAllSelected)
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark")
                            .foregroundColor(.white)
                            .font(.system(size: 10, weight: .bold))
                            .background(
                                Circle()
                                    .fill(isAllSelected ?
                                          Color(red: 1.0, green: 0.42, blue: 0.51) :
                                          Color(white: 0.82))
                                    .frame(width: 18, height: 18)
                            )
                        Text("전체선택")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
            .padding(.bottom, 6)

            Divider()
            List {
                ForEach(currentWordsBinding) { $word in
                    HStack(alignment: .top, spacing: 10) {
                        Button(action: {
                            word.isSelected.toggle()
                        }) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.white)
                                .font(.system(size: 15, weight: .bold))
                                .background(
                                    Circle()
                                        .fill(word.isSelected ?
                                              Color(red: 1.0, green: 0.42, blue: 0.51) :
                                              Color(white: 0.82))
                                        .frame(width: 28, height: 28)
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                        .frame(width: 28, height: 28)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(word.hiragana)
                                .font(.caption)
                                .foregroundColor(.gray)

                            HStack {
                                Text(word.kanji).font(.headline)
                                Spacer()
                                Text(word.meaning).font(.subheadline)
                                Spacer()
                                Text(word.day).font(.caption).foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.vertical, 5)
                }
            }
            .listStyle(PlainListStyle())
        }
        .onReceive(NotificationCenter.default.publisher(for: .vocabBookmarkChanged)) { note in
            guard
                let info = note.userInfo,
                let hiragana = info["hiragana"] as? String,
                let kanji = info["kanji"] as? String,
                let meaning = info["meaning"] as? String,
                let day = info["day"] as? String,
                let isOn = info["isOn"] as? Bool
            else { return }

            let newWord = Word(hiragana: hiragana, kanji: kanji, meaning: meaning, day: day)

            if isOn {
                if !learningWords.contains(where: { $0.kanji == kanji && $0.hiragana == hiragana }) {
                    learningWords.insert(newWord, at: 0) // 맨 위에 추가
                }
            } else {
                learningWords.removeAll { $0.kanji == kanji && $0.hiragana == hiragana }
            }
        }
    }

    private var currentWordsBinding: Binding<[Word]> {
        selectedTab == .learning ? $learningWords : $conversationWords
    }

    private func deleteSelectedWords() {
        if selectedTab == .learning {
            learningWords.removeAll { $0.isSelected }
        } else {
            conversationWords.removeAll { $0.isSelected }
        }
    }

    private func selectAllWords(_ select: Bool) {
        if selectedTab == .learning {
            learningWords = learningWords.map {
                var copy = $0
                copy.isSelected = select
                return copy
            }
        } else {
            conversationWords = conversationWords.map {
                var copy = $0
                copy.isSelected = select
                return copy
            }
        }
    }
}
