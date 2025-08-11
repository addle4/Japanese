import SwiftUI

struct Step5_CompositionView: View {
    var onComplete: () -> Void

    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                VStack(spacing: 10) {
                    Spacer().frame(height: 20)
                    Text("Step 5 : 어휘/문법 학습")
                        .font(.system(size: 24, weight: .bold))
                    Text("장면에 나온 주요 표현이에요! 복습해 볼까요?")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                VStack(spacing: 8) {
                    HStack(spacing: 0) {
                        Text("俺").foregroundColor(.pink)
                        Text("が ").foregroundColor(.black)
                        Text("いれ").foregroundColor(.pink)
                        Text("ば ").foregroundColor(.black)
                        Text("お前").foregroundColor(.pink)
                        Text("は ").foregroundColor(.black)
                        Text("最強").foregroundColor(.pink)
                        Text("だ！").foregroundColor(.black)
                    }
                    .font(.title3.bold())

                    Text("내가 있으면 너는 최강이야!")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .shadow(radius: 2)

                HStack {
                    Spacer()
                    Text("핵심 단어")
                        .font(.title3.bold())
                        .offset(x: 35, y:35)
                    Spacer()
                    Image("mong")
                        .offset(x: -48, y: 23)
                }
                .padding(.horizontal)

                VStack(spacing: 0) {
                    Spacer()
                    WordRow(step: "STEP 1", furigana: nil, kanji: "", meaning: "")
                    Divider()
                    Spacer(); Spacer()

                    WordRow(step: nil, furigana: "さいきょう", kanji: "最強", meaning: "최강")
                    Divider()
                    Spacer(); Spacer()

                    WordRow(step: nil, furigana: nil, kanji: "いれる", meaning: "いる(있다)의 가정형")
                    Divider()
                    Spacer(); Spacer()

                    WordRow(step: nil, furigana: "おまえ", kanji: "お前", meaning: "너(친근한 사이)")
                    Divider()
                    Spacer(); Spacer()

                    WordRow(step: nil, furigana: "おれ", kanji: "俺", meaning: "나 (남자아이가 쓰는)")
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .padding(.horizontal)
                .shadow(radius: 1)

                Spacer()

                Button(action: onComplete) {
                    Text("학습완료")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 1.0, green: 107/255, blue: 129/255))
                        .cornerRadius(15)
                        .padding(.horizontal)
                }
            }
            .padding(.top, 20)
        }
    }
}

struct WordRow: View {
    var step: String? = nil
    var furigana: String? = nil
    var kanji: String
    var meaning: String

    @State private var isBookmarked: Bool = false

    var body: some View {
        HStack(alignment: .top) {
            if let step = step {
                Text(step)
                    .font(.caption2)
                    .padding(5)
                    .background(Color.pink.opacity(0.3))
                    .cornerRadius(8)
                    .frame(width: 48)
                    .offset(y:-10)
            } else {
                Color.clear.frame(width: 48)
            }

            VStack(alignment: .leading, spacing: 2) {
                if let furigana = furigana { Text(furigana).font(.caption) }
                Text(kanji).font(.headline)
            }

            Spacer()

            Text(meaning)
                .font(.subheadline)
                .foregroundColor(.gray)

            if step == nil {
                Button(action: {
                    isBookmarked.toggle()
                    NotificationCenter.default.post(
                        name: AppNotification.vocabBookmarkChanged,
                        object: nil,
                        userInfo: [
                            "hiragana": furigana ?? "",
                            "kanji": kanji,
                            "meaning": meaning,
                            "day": "Day1",
                            "isOn": isBookmarked
                            // source 키 없음 → 오늘의 학습으로 들어감
                        ]
                    )                }) {
                    Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                        .foregroundColor(isBookmarked ? .pink : .gray)
                        .padding(.leading, 4)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}
