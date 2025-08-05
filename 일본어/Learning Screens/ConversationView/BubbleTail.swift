import SwiftUI

struct BubbleTail: View {
    let isUser: Bool

    var body: some View {
        Triangle()
            .fill(Color.white)
            .frame(width: 15, height: 10)
            .rotationEffect(.degrees(isUser ? 45 : -45))
            .background(Color.black.frame(width: 16, height: 11).rotationEffect(.degrees(isUser ? 45 : -45)))
            .offset(x: isUser ? 5 : -5)
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}
