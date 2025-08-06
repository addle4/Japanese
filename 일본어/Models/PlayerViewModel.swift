import AVKit

class PlayerViewModel: ObservableObject {
    @Published var playbackRate: Float = 1.0 {
        didSet {
            player.rate = playbackRate
        }
    }

    let player: AVPlayer

    init() {
        if let url = Bundle.main.url(forResource: "신 도라에몽 오프닝_꿈을 이루어줘(일본어)(발음, 자막 포함) [FHm9tuXz1uE]", withExtension: "mp4") {
            self.player = AVPlayer(url: url)
        } else {
            self.player = AVPlayer()
        }
    }

    func play() {
        player.play()
        player.rate = playbackRate
    }

    func pause() {
        player.pause()
    }
}
