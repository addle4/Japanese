import SwiftUI
// MARK: - 획순 표시 뷰
struct StrokeOrderView: View {
    let character: String

    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                Text(character).font(.largeTitle)
                Circle().fill(Color.red).frame(width: 8, height: 8).offset(x: -5, y: -15)
            }
            ZStack {
                Text(character).font(.largeTitle)
                Circle().fill(Color.red).frame(width: 8, height: 8).offset(x: 5, y: 0)
            }
            ZStack {
                Text(character).font(.largeTitle)
                Circle().fill(Color.red).frame(width: 8, height: 8).offset(x: -10, y: 10)
            }
        }
        .padding()
        .background(Color.darkBackground)
        .cornerRadius(15)
        .foregroundColor(.white.opacity(0.8))
    }
}

