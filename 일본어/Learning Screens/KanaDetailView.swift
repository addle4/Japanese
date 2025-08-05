import SwiftUI

struct KanaDetailView: View {
    let character: KanaCharacter
    var onClose: () -> Void

    @State private var showStroke = false

    private var koreanPronunciation: String {
        let mapping: [String: String] = [
            "a": "아", "i": "이", "u": "우", "e": "에", "o": "오",
            "ka": "카", "ki": "키", "ku": "쿠", "ke": "케", "ko": "코",
            "sa": "사", "shi": "시", "su": "스", "se": "세", "so": "소",
            "ta": "타", "chi": "치", "tsu": "츠", "te": "테", "to": "토",
            "na": "나", "ni": "니", "nu": "누", "ne": "네", "no": "노",
            "ha": "하", "hi": "히", "fu": "후", "he": "헤", "ho": "호",
            "ma": "마", "mi": "미", "mu": "무", "me": "메", "mo": "모",
            "ya": "야", "yu": "유", "yo": "요", "ra": "라", "ri": "리",
            "ru": "루", "re": "레", "ro": "로", "wa": "와", "n": "응"
        ]
        return mapping[character.pronunciation] ?? ""
    }

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text(character.gyo)
                    .font(.headline)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.accentPink.opacity(0.2))
                    .foregroundColor(.accentPink)
                    .cornerRadius(20)
                Spacer()
            }

            Text(character.kana)
                .font(.system(size: 120, weight: .bold))
                .foregroundColor(.white)

            VStack {
                Text("발음")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.6))

                HStack(alignment: .firstTextBaseline, spacing: 10) {
                    Text("\(character.pronunciation) / \(koreanPronunciation)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Button(action: {}) {
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.title2)
                            .foregroundColor(.accentYellow)
                    }
                }
            }

            VStack {
                Text("획순")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.6))

                if showStroke {
                    StrokeOrderView(character: character.kana)
                }
            }
        }
        .padding(30)
        .background(Color.cardBackground)
        .cornerRadius(30)
        .padding(30)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                showStroke = true
            }
        }
        .overlay(
            Button(action: onClose) {
                Image(systemName: "xmark.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
            }
            .padding(10),
            alignment: .topTrailing
        )
    }
}

