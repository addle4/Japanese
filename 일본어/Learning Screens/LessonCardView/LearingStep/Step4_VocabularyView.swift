// Step4_VocabularyView.swift

import SwiftUI
import AVKit

// MARK: - 후리가나 모델/뷰
struct FuriganaToken: Identifiable {
    let id = UUID()
    let base: String
    let ruby: String?
    let highlight: Bool
}

struct FuriganaTextLine: View {
    let tokens: [FuriganaToken]
    var body: some View {
        HStack(spacing: 8) {
            ForEach(tokens) { t in
                VStack(spacing: 2) {
                    if let r = t.ruby, !r.isEmpty {
                        Text(r)
                            .font(.caption2)
                            .foregroundColor(.black.opacity(0.7))
                            .lineLimit(1)
                            .fixedSize()
                    }
                    Text(t.base)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(t.highlight ? .pink : .black)
                        .fixedSize()
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Step 4
struct Step4_VocabularyView: View {
    var onComplete: () -> Void
    @ObservedObject var viewModel: PlayerViewModel
    @StateObject private var recognizer = SpeechRecognizer()

    let targetSentence = "俺達は血液だ。滞り無く流れろ。酸素を回せ、脳が正常に働くために。"

    private let line1: [FuriganaToken] = [
        .init(base: "俺達", ruby: "おれたち", highlight: true),
        .init(base: "は", ruby: nil, highlight: false),
        .init(base: "血液", ruby: "けつえき", highlight: true),
        .init(base: "だ。", ruby: nil, highlight: false),
        .init(base: "滞り", ruby: "とどこおり", highlight: true),
        .init(base: "無く", ruby: "なく", highlight: true),
        .init(base: "流れろ。", ruby: "ながれろ", highlight: true)
    ]
    private let line2: [FuriganaToken] = [
        .init(base: "酸素", ruby: "さんそ", highlight: true),
        .init(base: "を", ruby: nil, highlight: false),
        .init(base: "回せ、", ruby: "まわせ", highlight: true),
        .init(base: "脳", ruby: "のう", highlight: true),
        .init(base: "が", ruby: nil, highlight: false),
        .init(base: "正常", ruby: "せいじょう", highlight: true),
        .init(base: "に", ruby: nil, highlight: false),
        .init(base: "働く", ruby: "はたらく", highlight: true),
        .init(base: "ために。", ruby: "ために", highlight: true)
    ]

    var body: some View {
        VStack(spacing: 10) {
            // 제목 & 부제
            Text("Step 4 : 따라 말하기")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.top, 30)

            Text("장면에 나온 주요 표현이에요! 복습해 볼까요?")
                .font(.subheadline)
                .foregroundColor(.gray)

            Spacer().frame(height: 25)

            // 영상
            CustomAVPlayerView(player: viewModel.player)
                .frame(height: 250)
                .cornerRadius(20)
                .padding(.horizontal, 24)
                .frame(maxWidth: 560)

            // 문장 박스
            VStack(spacing: 10) {
                FuriganaTextLine(tokens: line1)
                FuriganaTextLine(tokens: line2)
            }
            .padding(14)
            .background(Color(red: 1.0, green: 0.9, blue: 0.9))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 3)
            .padding(.horizontal, 24)
            .frame(maxWidth: 560)
            .padding(.top, 10)

            Spacer()

            // 마이크 버튼
            Button {
                if recognizer.isRecording { recognizer.stopRecording() }
                else { recognizer.startRecording() }
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

            // 인식 텍스트
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
                }
                .padding(10)
                .background(Color.white.opacity(0.95))
                .cornerRadius(10)
                .padding(.horizontal, 24)
            }

            Text("정확도: \(recognizer.calculateSimilarity(to: targetSentence))%")
                .font(.headline)
                .foregroundColor(.green)

            Spacer(minLength: 20)

            // 하단 버튼
            AppButton(title: "제출하기", action: onComplete)
        }
        .onAppear { viewModel.play() }
        .onDisappear {
            viewModel.pause()
            if recognizer.isRecording { recognizer.stopRecording() }
        }
    }
}

//// Step4_VocabularyView.swift
//
//import SwiftUI
//import AVKit
//
//struct Step4_VocabularyView: View {
//    var onComplete: () -> Void
//
//    @ObservedObject var viewModel: PlayerViewModel   // 🔧 외부 주입
//    @StateObject private var recognizer = SpeechRecognizer()
//
//    let targetSentence = "俺がいればお前は最強だ"
//
//    var body: some View {
//        ZStack {
//            VStack(spacing: 10) {
//                Text("Step 4 : 따라 말하기")
//                    .font(.title)
//                    .fontWeight(.bold)
//                    .foregroundColor(.black)
//                    .padding(.top, 30)
//
//                Text("장면에 나온 주요 표현이에요! 복습해 볼까요?")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//
//                Spacer().frame(height: 25)
//
//                CustomAVPlayerView(player: viewModel.player)
//                    .frame(height: 250)
//                    .cornerRadius(20)
//                    .padding(.horizontal)
//
//                HStack(spacing: 0) {
//                    Text("俺")
//                        .foregroundColor(.pink)
//                    Text("が  ")
//                        .foregroundColor(.black)
//                    Text(" いれ ")
//                        .foregroundColor(.pink)
//                    Text("ば")
//                        .foregroundStyle(.black)
//                    Text("お前")
//                        .foregroundColor(.pink)
//                    Text("は ")
//                        .foregroundColor(.black)
//                    Text("最強")
//                        .foregroundColor(.pink)
//                    Text("だ！")
//                        .foregroundColor(.black)
//                }
//                .font(.title3)
//                .fontWeight(.bold)
//                .padding()
//                .background(Color(red: 1.0, green: 0.9, blue: 0.9))
//                .cornerRadius(12)
//                .padding(.top, 10)
//
//                Text("내가 있으면 너는 최강이야!")
//                    .font(.body)
//                    .foregroundColor(.black)
//
//                Spacer()
//
//                Button {
//                    if recognizer.isRecording {
//                        recognizer.stopRecording()
//                    } else {
//                        recognizer.startRecording()
//                    }
//                } label: {
//                    ZStack {
//                        Circle()
//                            .fill(recognizer.isRecording
//                                  ? Color(red: 1.0, green: 0.45, blue: 0.55)
//                                  : Color(red: 1.0, green: 0.86, blue: 0.90))
//                            .frame(width: 100, height: 100)
//                            .shadow(radius: recognizer.isRecording ? 8 : 2)
//                            .animation(.easeInOut(duration: 0.2), value: recognizer.isRecording)
//
//                        LottieView(animationName: "Gradient Music Mic", isPlaying: $recognizer.isRecording)
//                            .frame(width: 100, height: 100)
//                            .scaleEffect(recognizer.isRecording ? 1.12 : 1.0)
//                            .animation(.spring(response: 0.25, dampingFraction: 0.8), value: recognizer.isRecording)
//                    }
//                }
//                .buttonStyle(.plain)
//                .zIndex(1)
//
//                // 인식된 문장 (공백만인 경우 숨김)
//                let shownText = recognizer.recognizedText.trimmingCharacters(in: .whitespacesAndNewlines)
//                if !shownText.isEmpty {
//                    HStack(alignment: .top, spacing: 8) {
//                        Image(systemName: "text.bubble.fill")
//                            .font(.footnote)
//                            .foregroundColor(.accentBlue)
//
//                        Text(shownText)
//                            .font(.footnote)
//                            .foregroundColor(.black)
//                            .multilineTextAlignment(.leading)
//                            .lineLimit(nil)
//                            .fixedSize(horizontal: false, vertical: true)
//                    }
//                    .padding(10)
//                    .background(Color.white.opacity(0.95))
//                    .cornerRadius(10)
//                    .padding(.horizontal)
//                    .padding(.top, 8)
//                    .padding(.bottom, 8)
//                }
//
//                Text("정확도: \(recognizer.calculateSimilarity(to: targetSentence))%")
//                    .font(.headline)
//                    .foregroundColor(.green)
//
//                Spacer(minLength: 20)
//
//                AppButton(title: "제출하기", action: onComplete)
//            }
//            .onAppear { viewModel.play() }
//            .onDisappear {
//                viewModel.pause()
//                if recognizer.isRecording { recognizer.stopRecording() }
//            }
//            .transition(.asymmetric(insertion: .move(edge: .trailing),
//                                    removal: .move(edge: .leading)))
//        }
//        .onChange(of: recognizer.recognizedText) { newValue in
//            print("🗣 인식 갱신: \(newValue)")
//        }
//    }
//}
