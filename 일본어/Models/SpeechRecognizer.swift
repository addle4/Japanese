import Foundation
import AVFoundation
import Speech

class SpeechRecognizer: NSObject, ObservableObject {
    private let audioEngine = AVAudioEngine()
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ja-JP"))!

    @Published var isRecording = false
    @Published var recognizedText: String = ""

    override init() {
        super.init()
        SFSpeechRecognizer.requestAuthorization { authStatus in
            if authStatus != .authorized {
                print("음성 인식 권한이 없습니다.")
            }
        }
    }

    func startRecording() {
        if audioEngine.isRunning {
            stopRecording()
            return
        }

        do {
            request = SFSpeechAudioBufferRecognitionRequest()
            guard let request = request else { return }

            let inputNode = audioEngine.inputNode
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.removeTap(onBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
                request.append(buffer)
            }

            audioEngine.prepare()
            try audioEngine.start()

            print("🎙 녹음 시작")

            isRecording = true
            recognizedText = ""

            recognitionTask = speechRecognizer.recognitionTask(with: request) { result, error in
                if let result = result {
                    DispatchQueue.main.async {
                        self.recognizedText = result.bestTranscription.formattedString
                    }
                }

                if let error = error {
                    print("음성 인식 에러: \(error.localizedDescription)")
                }
            }
        } catch {
            print("녹음 시작 실패: \(error.localizedDescription)")
        }
    }

    func stopRecording() {
        audioEngine.stop()
        request?.endAudio()
        audioEngine.inputNode.removeTap(onBus: 0)
        print("🛑 녹음 종료")
        isRecording = false
    }

    func calculateSimilarity(to target: String) -> Int {
        let normalizedTarget = target.lowercased().filter { !$0.isWhitespace }
        let normalizedSpeech = recognizedText.lowercased().filter { !$0.isWhitespace }

        let matches = zip(normalizedTarget, normalizedSpeech).filter { $0 == $1 }.count
        let maxLength = max(normalizedTarget.count, normalizedSpeech.count)
        guard maxLength > 0 else { return 0 }
        return Int((Double(matches) / Double(maxLength)) * 100)
    }
}
