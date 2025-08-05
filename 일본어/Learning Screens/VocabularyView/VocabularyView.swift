import SwiftUI

struct VocabularyView: View {
    var body: some View {
        ZStack {
            Color.darkBackground.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("내 단어장")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text("저장된 단어들을 복습해보세요")
                        .foregroundColor(.white.opacity(0.7))

                    ForEach(0..<5) { index in
                        VStack(alignment: .leading) {
                            Text("예시 단어 \(index + 1)")
                                .font(.title2)
                                .foregroundColor(.white)
                            Text("단어의 뜻, 발음, 예문 등 추가 가능")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.cardBackground)
                        .cornerRadius(12)
                    }
                }
                .padding()
            }
        }
        .navigationTitle("단어장")
        .navigationBarTitleDisplayMode(.inline)
    }
}
