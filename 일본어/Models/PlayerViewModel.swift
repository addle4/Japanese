import AVKit

class PlayerViewModel: ObservableObject {
    @Published var playbackRate: Float = 1.0 {
        didSet {
            player.rate = playbackRate
        }
    }

    let player: AVPlayer
    private var isInFullscreen: Bool = false

    init() {
        if let url = Bundle.main.url(forResource: "ハイキュー北信介名言 [it3tKC0ycu4]", withExtension: "mp4") {
            self.player = AVPlayer(url: url)
        } else {
            self.player = AVPlayer()
        }

        // 전체화면 상태 감지
        NotificationCenter.default.addObserver(self, selector: #selector(enteredFullscreen), name: UIWindow.didBecomeVisibleNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(exitedFullscreen), name: UIWindow.didBecomeHiddenNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func enteredFullscreen() {
        isInFullscreen = true
    }

    @objc private func exitedFullscreen() {
        isInFullscreen = false
    }

    func play() {
        player.play()
        player.rate = playbackRate
    }

    func pause() {
        // 전체화면 중일 때는 일시정지하지 않음
        if !isInFullscreen {
            player.pause()
        }
    }
}
