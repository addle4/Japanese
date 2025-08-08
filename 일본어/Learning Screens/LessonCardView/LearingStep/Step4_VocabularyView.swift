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
                    Text("俺").foregroundColor(.red)
                    Text("が ").foregroundColor(.black)
                    Text("いれば ").foregroundColor(.pink)
                    Text("お前").foregroundColor(.purple)
                    Text("は ").foregroundColor(.black)
                    Text("最強").foregroundColor(.red)
                    Text("だ！").foregroundColor(.black)
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

                Button {
                    if recognizer.isRecording {
                        recognizer.stopRecording()
                    } else {
                        recognizer.startRecording()
                    }
                } label: {
                    ZStack {
                        Circle()
                            .fill(recognizer.isRecording
                                  ? Color(red: 1.0, green: 0.45, blue: 0.55)
                                  : Color(red: 1.0, green: 0.86, blue: 0.90))
                            .frame(width: 100, height: 100)
                            .shadow(radius: recognizer.isRecording ? 8 : 2)
                            .animation(.easeInOut(duration: 0.2), value: recognizer.isRecording)

                        LottieView(animationName: "Gradient Music Mic", isPlaying: $recognizer.isRecording)
                            .frame(width: 100, height: 100)
                            .scaleEffect(recognizer.isRecording ? 1.12 : 1.0)
                            .animation(.spring(response: 0.25, dampingFraction: 0.8), value: recognizer.isRecording)
                    }
                }
                .buttonStyle(.plain)
                .zIndex(1)

                // 인식된 문장 (공백만인 경우 숨김)
                let shownText = recognizer.recognizedText.trimmingCharacters(in: .whitespacesAndNewlines)
                if !shownText.isEmpty {
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "text.bubble.fill")
                            .font(.footnote)
                            .foregroundColor(.accentBlue)

                        Text(shownText)
                            .font(.footnote)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(10)
                    .background(Color.white.opacity(0.95))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .padding(.bottom, 8)
                }

                Text("정확도: \(recognizer.calculateSimilarity(to: targetSentence))%")
                    .font(.headline)
                    .foregroundColor(.green)

                Spacer(minLength: 20)

                AppButton(title: "제출하기", action: onComplete)
            }
            .onAppear { viewModel.play() }
            .onDisappear {
                viewModel.pause()
                if recognizer.isRecording { recognizer.stopRecording() }
            }
            .transition(.asymmetric(insertion: .move(edge: .trailing),
                                    removal: .move(edge: .leading)))
        }
        .onChange(of: recognizer.recognizedText) { newValue in
            print("🗣 인식 갱신: \(newValue)")
        }
    }
}
