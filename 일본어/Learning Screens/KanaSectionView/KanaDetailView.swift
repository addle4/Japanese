import SwiftUI
import AVFoundation

// MARK: - 발음 재생 클래스
final class SpeechPlayer {
    static let shared = SpeechPlayer()
    private let synth = AVSpeechSynthesizer()
    
    private init() {
        try? AVAudioSession.sharedInstance().setCategory(.playback,
                                                         mode: .spokenAudio,
                                                         options: [.duckOthers])
        try? AVAudioSession.sharedInstance().setActive(true, options: [])
    }
    
    func speakJapanese(_ text: String) {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        let u = AVSpeechUtterance(string: text)
        u.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        u.rate  = 0.35        // 🔹 기존 0.45 → 0.35로 낮춰서 발음을 길게
        u.pitchMultiplier = 1.0
        synth.stopSpeaking(at: .immediate)
        synth.speak(u)
    }
}

// MARK: - KanaDetailView
struct KanaDetailView: View {
    let character: KanaCharacter
    var onClose: () -> Void
    
    private var koreanPronunciation: String {
        let mapping: [String: String] = [
            "a":"아","i":"이","u":"우","e":"에","o":"오",
            "ka":"카","ki":"키","ku":"쿠","ke":"케","ko":"코",
            "sa":"사","shi":"시","su":"스","se":"세","so":"소",
            "ta":"타","chi":"치","tsu":"츠","te":"테","to":"토",
            "na":"나","ni":"니","nu":"누","ne":"네","no":"노",
            "ha":"하","hi":"히","fu":"후","he":"헤","ho":"호",
            "ma":"마","mi":"미","mu":"무","me":"메","mo":"모",
            "ya":"야","yu":"유","yo":"요",
            "ra":"라","ri":"리","ru":"루","re":"레","ro":"로",
            "wa":"와","n":"응"
        ]
        return mapping[character.pronunciation] ?? ""
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // 상단 라벨
            HStack {
                Text(character.gyo)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(red: 1.0, green: 0.4196, blue: 0.5059)) // 로즈핑크
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                Spacer()
            }
            
            // 큰 문자
            Text(character.kana)
                .font(.system(size: 120, weight: .bold))
                .foregroundColor(.black)
            
            // 발음 섹션
            VStack(spacing: 8) {
                Text("발음")
                    .font(.subheadline)
                    .foregroundColor(.black.opacity(0.6))
                
                HStack(alignment: .firstTextBaseline, spacing: 10) {
                    Text("\(character.pronunciation) / \(koreanPronunciation)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    // ✅ 발음 재생 버튼
                    Button {
                        SpeechPlayer.shared.speakJapanese(character.kana)
                    } label: {
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.title2)
                            .foregroundColor(Color(red: 1.0, green: 0.8, blue: 0.0))
                    }
                    .buttonStyle(.plain)
                }
            }
            
            // 획순 섹션
            VStack(spacing: 10) {
                Text("획순")
                    .font(.subheadline)
                    .foregroundColor(.black.opacity(0.6))
                
                StrokeOrderView(character: character.kana)
            }
        }
        .padding(28)
        .background(Color(red: 238/255, green: 238/255, blue: 238/255))// 카드 배경
        .cornerRadius(30)
        .shadow(color: .black.opacity(0.15), radius: 20)
        .padding(30)
        // ✅ 닫기 버튼
        .overlay(
            Button(action: onClose) {
                Image(systemName: "xmark.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
            }
            .buttonStyle(.plain)
            .padding(10),
            alignment: .topTrailing
        )
    }
}
