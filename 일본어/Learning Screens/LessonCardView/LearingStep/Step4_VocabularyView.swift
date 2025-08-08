// Step4_VocabularyView.swift

import SwiftUI
import AVKit

struct Step4_VocabularyView: View {
    var onComplete: () -> Void
    @StateObject private var viewModel = PlayerViewModel()
    @StateObject private var recognizer = SpeechRecognizer()

    let targetSentence = "俺がいればお前は最強だ"

    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                Text("Step 4 : 따라 말하기")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.top, 30)

                Text("장면에 나온 주요 표현이에요! 복습해 볼까요?")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Spacer().frame(height: 25)

                CustomAVPlayerView(player: viewModel.player)
                    .frame(height: 250)
                    .cornerRadius(20)
                    .padding(.horizontal)

                HStack(spacing: 0) {
                    Text("俺")
                        .foregroundColor(.pink)
                    Text("が  ")
                        .foregroundColor(.black)
                    Text(" いれ ")
                        .foregroundColor(.pink)
                    Text("ば")
                        .foregroundStyle(.black)
                    Text("お前")
                        .foregroundColor(.pink)
                    Text("は ")
                        .foregroundColor(.black)
                    Text("最強")
                        .foregroundColor(.pink)
                    Text("だ！")
                        .foregroundColor(.black)
                }
                .font(.title3)
                .fontWeight(.bold)
                .padding()
                .background(Color(red: 1.0, green: 0.9, blue: 0.9))
                .cornerRadius(12)
                .padding(.top, 10)

                Text("내가 있으면 너는 최강이야!")
                    .font(.body)
                    .foregroundColor(.black)

                Spacer()

                // 마이크 버튼 (Lottie 애니메이션 사용)
                Button(action: {
                    if recognizer.isRecording {
                        recognizer.stopRecording()
                    } else {
                        recognizer.startRecording()
                    }
                }) {
                    ZStack {
                        // 뒷 배경 Circle (고정 색상)
                        Circle()
                            .fill(Color(red: 1.0, green: 0.5, blue: 0.6))
                            .frame(width: 100, height: 100)

                        // Lottie 애니메이션
                        LottieView(animationName: "Gradient Music Mic", isPlaying: $recognizer.isRecording)
                            .frame(width: 100, height: 100)
                            .scaleEffect(1.1)
                    }
                }
                .buttonStyle(PlainButtonStyle()) // 클릭 애니메이션 방지
                if !recognizer.recognizedText.isEmpty {
                    Text("🗣 인식된 문장: \(recognizer.recognizedText)")
                        .font(.footnote)
                        .padding(.top, 8)

                    Text("정확도: \(recognizer.calculateSimilarity(to: targetSentence))%")
                        .font(.headline)
                        .foregroundColor(.green)
                }

                Spacer(minLength: 20)

                AppButton(title: "제출하기", action: onComplete)
            }
            .onAppear { viewModel.play() }
            .onDisappear { viewModel.pause() }
            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
        }
    }
}
