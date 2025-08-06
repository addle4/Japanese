import SwiftUI
import AVKit

struct Step4_VocabularyView: View {
    var onComplete: () -> Void
    @StateObject private var viewModel = PlayerViewModel()

    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                // 상단 제목 및 설명
                Text("Step 4 : 따라 말하기")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.top, 30)

                Text("장면에 나온 주요 표현이에요! 복습해 볼까요?")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                // Step1 과 동일한 위치를 맞추기 위해 고정 spacer
                Spacer().frame(height: 25)

                // 영상
                CustomAVPlayerView(player: viewModel.player)
                    .frame(height: 250)
                    .cornerRadius(20)
                    .padding(.horizontal)

                // 표현 문장 (일본어 강조)
                HStack(spacing: 0) {
                    Text("俺")
                        .foregroundColor(.red)
                    Text("が ")
                        .foregroundColor(.black)
                    Text("いれば ")
                        .foregroundColor(.pink)
                    Text("お前")
                        .foregroundColor(.purple)
                    Text("は ")
                        .foregroundColor(.black)
                    Text("最強")
                        .foregroundColor(.red)
                    Text("だ！")
                        .foregroundColor(.black)
                }
                .font(.title3)
                .fontWeight(.bold)
                .padding()
                .background(Color(red: 1.0, green: 0.9, blue: 0.9))
                .cornerRadius(12)
                .padding(.top, 10)

                // 한국어 해석
                Text("내가 있으면 너는 최강이야!")
                    .font(.body)
                    .foregroundColor(.black)

                Spacer()

                // 마이크 버튼
                Button(action: {
                    // 녹음 또는 다음 단계
                }) {
                    Image(systemName: "mic.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                        .padding(30)
                        .background(Color(red: 1.0, green: 0.5, blue: 0.6))
                        .clipShape(Circle())
                }

                Spacer(minLength: 20)
                
                AppButton(title: "제출하기", action: onComplete)
            }
            .onAppear {
                viewModel.play()
            }
            .onDisappear {
                viewModel.pause()
            }
            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
        }
    }
}
