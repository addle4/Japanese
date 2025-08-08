// SpeechRecognizer.swift

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
        SFSpeechRecognizer.requestAuthorization { status in
            if status != .authorized {
                print("음성 인식 권한이 없습니다.")
            }
        }
        AVAudioApplication.requestRecordPermission { granted in
            if !granted { print("마이크 권한이 없습니다.") }
        }
    }

    func startRecording() {
        if audioEngine.isRunning {
            stopRecording()
            return
        }

        recognitionTask?.cancel()
        recognitionTask = nil
        request = nil

        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .measurement, options: [.defaultToSpeaker, .mixWithOthers])
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("AVAudioSession 설정 실패: \(error.localizedDescription)")
            return
        }

        let req = SFSpeechAudioBufferRecognitionRequest()
        req.shouldReportPartialResults = true
        self.request = req

        let input = audioEngine.inputNode
        let format = input.outputFormat(forBus: 0)
        input.removeTap(onBus: 0)
        input.installTap(onBus: 0, bufferSize: 1024, format: format) { [weak self] buffer, _ in
            self?.request?.append(buffer)
        }

        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine 시작 실패: \(error.localizedDescription)")
            cleanupAfterStop()
            return
        }

        DispatchQueue.main.async {
            self.isRecording = true
            self.recognizedText = ""
        }

        recognitionTask = speechRecognizer.recognitionTask(with: req) { [weak self] result, error in
            guard let self else { return }

            if let result = result {
                let text = result.bestTranscription.formattedString
                DispatchQueue.main.async { self.recognizedText = text }
                if result.isFinal { self.finish() }
            }

            if let error = error {
                print("음성 인식 에러: \(error.localizedDescription)")
                self.finish()
            }
        }

        print("🎙 녹음 시작")
    }

    func stopRecording() {
        finish()
        print("🛑 녹음 종료")
    }

    private func finish() {
        if audioEngine.isRunning { audioEngine.stop() }
        audioEngine.inputNode.removeTap(onBus: 0)
        request?.endAudio()
        recognitionTask?.cancel()
        DispatchQueue.main.async { self.isRecording = false }
    }

    private func cleanupAfterStop() {
        audioEngine.inputNode.removeTap(onBus: 0)
        request?.endAudio()
        recognitionTask?.cancel()
        DispatchQueue.main.async { self.isRecording = false }
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
