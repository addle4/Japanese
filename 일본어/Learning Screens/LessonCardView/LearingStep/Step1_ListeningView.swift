import SwiftUI
import AVKit

// MARK: - Step 1: 몰입해서 듣기
struct Step1_ListeningView: View {
    var onComplete: () -> Void

    @State private var playbackRate: Float = 1.0
    @State private var player: AVPlayer? = nil

    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                Text("Step 1: 몰입해서 듣기")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.top, 30)

                Text("자막 없이 장면에 집중하며 들어보세요.")
                    .font(.subheadline)
                    .foregroundStyle(.gray)

                Spacer().frame(height: 25)

                if let player = player {
                    VideoPlayerView(player: player)
                        .frame(height: 250)
                        .cornerRadius(20)
                        .padding(.horizontal)

                    // 배속 조절 슬라이더
                    HStack {
                        Text("배속: \(String(format: "%.1fx", playbackRate))")
                            .font(.footnote)
                            .foregroundColor(.gray)

                        Slider(value: $playbackRate, in: 0.5...2.0, step: 0.25)
                            .onChange(of: playbackRate) { oldValue, newValue in
                                player.rate = newValue
                                if player.timeControlStatus != .playing {
                                    player.play()
                                }
                            }
                    }
                    .padding(.horizontal)
                } else {
                    // fallback UI
                    Rectangle()
                        .fill(Color.black.opacity(0.2))
                        .overlay(Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 44))
                            .foregroundColor(.white.opacity(0.5)))
                        .frame(height: 250)
                        .cornerRadius(20)
                        .padding(.horizontal)
                }

                Spacer()

                AppButton(title: "내용 파악 완료! 다음으로", action: onComplete)
            }
            .onAppear {
                if let url = Bundle.main.url(forResource: "신 도라에몽 오프닝_꿈을 이루어줘(일본어)(발음, 자막 포함) [FHm9tuXz1uE]", withExtension: "mp4") {
                    self.player = AVPlayer(url: url)
                    self.player?.play()
                    self.player?.rate = playbackRate
                }
            }
            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
        }
    }
}
