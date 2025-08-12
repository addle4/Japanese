import SwiftUI

extension Notification.Name {
    static let vocabBookmarkChanged = Notification.Name("vocabBookmarkChanged")
}

struct Step5_CompositionView: View {
    var onComplete: () -> Void

    var body: some View {
        // 이미 가지고 있는 RatioAnchoredButtonLayout 사용
        RatioAnchoredButtonLayout(
            buttonYRatio: 0.90,
            buttonReservedHeight: 84,
            horizontalMargin: 16
        ) {
            // 콘텐츠는 스크롤 가능하게
            ScrollView {
                VStack(spacing: 24) {
                    // 헤더
                    VStack(spacing: 10) {
                        Spacer().frame(height: 20)
                        Text("Step 5 : 어휘/문법 학습")
                            .font(.system(size: 24, weight: .bold))
                        Text("장면에 나온 주요 표현이에요! 복습해 볼까요?")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }

                    // 예문 카드
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

                    // 섹션 타이틀 + 이미지
                    HStack {
                        Spacer()
                        Text("핵심 단어")
                            .font(.title3.bold())
                            .offset(x: 35, y: 35)
                        Spacer()
                        Image("mong")
                            .offset(x: -48, y: 23)
                    }
                    .padding(.horizontal)

                    // 단어 리스트 (여백 정리)
                    VStack(spacing: 0) {
                        WordRow(step: "STEP 1", furigana: nil, kanji: "", meaning: "")
                            .padding(.vertical, 8)
                        Divider().padding(.leading, 60)

                        WordRow(step: nil, furigana: "さいきょう", kanji: "最強", meaning: "최강")
                            .padding(.vertical, 10)
                        Divider().padding(.leading, 60)

                        WordRow(step: nil, furigana: nil, kanji: "いれる", meaning: "いる(있다)의 가정형")
                            .padding(.vertical, 10)
                        Divider().padding(.leading, 60)

                        WordRow(step: nil, furigana: "おまえ", kanji: "お前", meaning: "너(친근한 사이)")
                            .padding(.vertical, 10)
                        Divider().padding(.leading, 60)

                        WordRow(step: nil, furigana: "おれ", kanji: "俺", meaning: "나 (남자아이가 쓰는)")
                            .padding(.vertical, 10)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .padding(.horizontal)
                    .shadow(radius: 1)

                    Spacer(minLength: 12) // 버튼과 시각적 여유
                }
                .padding(.top, 20)
            }
        } button: {
            // 하단 버튼을 비율 위치에 고정
            Button(action: onComplete) {
                Text("학습완료")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 1.0, green: 107/255, blue: 129/255))
                    .cornerRadius(15)
            }
            // ⬆︎ RatioAnchoredButtonLayout 이 가로 폭을 잡아주므로
            // 여기서는 .padding(.horizontal) 불필요 (넣으면 레일에서 벗어남)
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
        HStack(alignment: .top, spacing: 12) {
            if let step = step {
                Text(step)
                    .font(.caption2)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 8)
                    .background(Color.pink.opacity(0.3))
                    .cornerRadius(8)
                    .frame(width: 60, alignment: .center) // Divider 들여쓰기와 맞춤
                    .offset(y: -6)
            } else {
                Color.clear.frame(width: 60)
            }

            // 일본어 단어
            VStack(alignment: .leading, spacing: 4) {
                if let furigana = furigana, !furigana.isEmpty {
                    Text(furigana).font(.caption)
                }
                Text(kanji).font(.headline)
            }

            Spacer(minLength: 12)

            Text(meaning)
                .font(.subheadline)
                .foregroundColor(.gray)
                .fixedSize(horizontal: false, vertical: true)

            if step == nil {
                Button(action: {
                    isBookmarked.toggle()
                    NotificationCenter.default.post(
                        name: .vocabBookmarkChanged,
                        object: nil,
                        userInfo: [
                            "hiragana": furigana ?? "",
                            "kanji": kanji,
                            "meaning": meaning,
                            "day": "Day1",
                            "isOn": isBookmarked
                        ]
                    )
                }) {
                    Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                        .foregroundColor(isBookmarked ? .pink : .gray)
                        .padding(.leading, 4)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}
