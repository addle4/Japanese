import SwiftUI

struct StrokeOrderView: View {
    let character: String
    @State private var isVisible = false

    private let markerOffsets: [CGSize] = [
        CGSize(width: -5, height: -15),
        CGSize(width: 5, height: 0),
        CGSize(width: -10, height: 10)
    ]


    var body: some View {
        Group {
            if isVisible {
                HStack(spacing: 15) {
                    ForEach(0..<markerOffsets.count, id: \.self) { index in
                        ZStack {
                            Text(character)
                                .font(.largeTitle)
                            Circle()
                                .fill(Color.red)
                                .frame(width: 8, height: 8)
                                .offset(markerOffsets[index])
                        }
                    }
                }
                .padding()
                .background(Color.darkBackground.opacity(0.5))
                .cornerRadius(15)
                .foregroundColor(.white.opacity(0.8))
                .drawingGroup()
            } else {
                ProgressView()
                    .frame(height: 80)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isVisible = true
            }
        }
    }
}

