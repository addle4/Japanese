import SwiftUI

// MARK: - Model
struct LearningOverview {
    var todayProgress: Double
    var totalProblems: Int
    var todayLearnedSeconds: Int
    var minutesLearnedTotal: Int
}

struct LearningOverviewView: View {
    var stats: LearningOverview
    var onStartToday: (() -> Void)? = nil

    @Environment(\.scenePhase) private var scenePhase
    @State private var todaySeconds: Int = 0
    @State private var timer: Timer?

    struct DayStat: Identifiable {
        let id = UUID()
        let label: String
        let newWords: Int
        let reviewWords: Int
        let correctness: Double
    }

    private let chartData: [DayStat] = [
        .init(label: "16일 전",     newWords: 4, reviewWords: 5, correctness: 0.67),
        .init(label: "2025-08-06", newWords: 6, reviewWords: 4, correctness: 0.98),
        .init(label: "오늘",        newWords: 3, reviewWords: 4, correctness: 0.52),
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                // MARK: 섹션 타이틀 (핑크 탭 스타일)
                VStack(alignment: .leading, spacing: 8) {
                    Text("학습내역")
                        .font(.headline)
                        .foregroundStyle(Color.brandPink.opacity(0.9))
                        .padding(.top, 14)

                    ZStack(alignment: .leading) {
                        Rectangle().fill(Color.black.opacity(0.1)).frame(height: 1)
                        Rectangle().fill(Color.brandPink.opacity(0.6))
                            .frame(width: 86, height: 3)
                            .offset(y: 1)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 8)

                // MARK: 카드
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.06), radius: 8, y: 3)

                    VStack(spacing: 14) {

                        // 범례: 좌측 세로(직선), 우측 동그라미
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 8) {
                                LegendLine(color: Color.brandPink.opacity(0.28), label: "새로 배운 문장 :")
                                LegendLine(color: Color.brandPink.opacity(0.85), label: "복습 문장 :")
                            }
                            Spacer()
                            LegendDot(color: .gray.opacity(0.9), label: "복습 정답률")
                        }
                        .font(.caption)
                        .padding(.top, 12)
                        .padding(.horizontal, 16)

                        // 가운데 화살표
                        HStack(spacing: 40) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(Color.black.opacity(0.7))
                            Image(systemName: "chevron.right")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(Color.black.opacity(0.7))
                        }
                        .padding(.top, 2)

                        GeometryReader { geo in
                            // 레이아웃 상수
                            let horizontalPadding: CGFloat = 20
                            let bottomPadding: CGFloat = 18   // ⬅️ 바닥 정렬에 사용
                            let availableWidth = geo.size.width - horizontalPadding * 2
                            let maxBar = max(chartData.map { max($0.newWords, $0.reviewWords) }.max() ?? 1, 1)
                            let maxHeight = geo.size.height - 46   // 위 여백 보정
                            let count = chartData.count

                            ZStack {

                                // 가로 가이드라인
                                ForEach(1...3, id: \.self) { i in
                                    let y = 12 + (maxHeight * CGFloat(i) / 3.0) - bottomPadding/3
                                    Path { p in
                                        p.move(to: CGPoint(x: horizontalPadding, y: y))
                                        p.addLine(to: CGPoint(x: geo.size.width - horizontalPadding, y: y))
                                    }
                                    .stroke(Color.gray.opacity(0.18), lineWidth: 1)
                                }

//                                // 하단 굵은 핑크 베이스라인 (막대 바닥과 정확히 일치)
//                                Path { p in
//                                    let y = 12 + maxHeight - bottomPadding
//                                    p.move(to: CGPoint(x: horizontalPadding, y: y))
//                                    p.addLine(to: CGPoint(x: geo.size.width - horizontalPadding, y: y))
//                                }
//                                .stroke(Color.brandPink.opacity(0.8), lineWidth: 2)

                                // 정답률 꺾은선 (조금 더 연한 회색)
                                Path { path in
                                    for (i, d) in chartData.enumerated() {
                                        let x = horizontalPadding + availableWidth * (CGFloat(i) / CGFloat(max(count - 1, 1)))
                                        let y = 12 + (maxHeight - bottomPadding) * (1 - CGFloat(d.correctness))
                                        if i == 0 { path.move(to: CGPoint(x: x, y: y)) }
                                        else { path.addLine(to: CGPoint(x: x, y: y)) }
                                    }
                                }
                                .stroke(Color.gray.opacity(0.45), style: StrokeStyle(lineWidth: 2, lineJoin: .round))

                                // 포인트
                                ForEach(Array(chartData.enumerated()), id: \.offset) { i, d in
                                    let x = horizontalPadding + availableWidth * (CGFloat(i) / CGFloat(max(count - 1, 1)))
                                    let y = 12 + (maxHeight - bottomPadding) * (1 - CGFloat(d.correctness))
                                    Circle().fill(Color.gray.opacity(0.7))
                                        .frame(width: 6, height: 6)
                                        .position(x: x, y: y)
                                }

                                // 막대 (좌: 연핑크=새로 배운, 우: 진핑크=복습)
                                HStack(alignment: .bottom, spacing: (availableWidth / CGFloat(count)) - 32) {
                                    ForEach(chartData) { d in
                                        let unit: CGFloat = 16
                                        let hNew = (maxHeight - bottomPadding) * CGFloat(d.newWords) / CGFloat(maxBar)
                                        let hReview = (maxHeight - bottomPadding) * CGFloat(d.reviewWords) / CGFloat(maxBar)

                                        HStack(alignment: .bottom, spacing: 8) {
                                            RoundedRectangle(cornerRadius: 0)
                                                .fill(Color.brandPink.opacity(0.28))
                                                .frame(width: unit, height: hNew)

                                            RoundedRectangle(cornerRadius: 0)
                                                .fill(Color.brandPink.opacity(0.85))
                                                .frame(width: unit, height: hReview)
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                                .padding(.horizontal, horizontalPadding)
                                .padding(.bottom, bottomPadding)

                            }
                            // X축 라벨을 막대 바로 아래에 붙여 배치
                            .overlay(alignment: .bottom) {
                                HStack {
                                    ForEach(chartData) { d in
                                        Text(d.label)
                                            .font(.caption2)
                                            .foregroundStyle(.black)
                                        if d.id != chartData.last?.id { Spacer() }
                                    }
                                }
                                .padding(.horizontal, horizontalPadding)
                                .padding(.bottom, 2)
                            }
                        }
                        .frame(height: 190)
                        .padding(.bottom, 10)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            }
        }
        .background(Color.brandPaper.ignoresSafeArea())
        .onAppear {
            todaySeconds = stats.todayLearnedSeconds
            startTimer()
        }
        .onDisappear { stopTimer() }
        .onChange(of: scenePhase) { _, newPhase in
            switch newPhase {
            case .active:   startTimer()
            case .inactive, .background: stopTimer()
            @unknown default: break
            }
        }
    }

    // MARK: - Timer
    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            todaySeconds += 1
        }
        RunLoop.main.add(timer!, forMode: .common)
    }
    private func stopTimer() { timer?.invalidate(); timer = nil }

    // MARK: - Util
    private func secondsToMinuteSecond(_ secs: Int) -> String {
        let m = secs / 60
        let s = secs % 60
        return "\(m)분 \(s)초"
    }
}

// MARK: - Legend Components
private struct LegendLine: View {
    let color: Color; let label: String
    var body: some View {
        HStack(spacing: 6) {
            Capsule().fill(color).frame(width: 18, height: 4)   // 직선 모양
            Text(label)
        }
    }
}
private struct LegendDot: View {
    let color: Color; let label: String
    var body: some View {
        HStack(spacing: 6) {
            Circle().fill(color).frame(width: 8, height: 8)
            Text(label)
        }
    }
}

// MARK: - Colors
extension Color {
    static let brandPink   = Color(hexString: "#FF6F8D")
    static let brandLight2 = Color(hexString: "#FFE2E6")
    static let brandPaper  = Color(hexString: "#FFF7F4")

    init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a,r,g,b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a,r,g,b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a,r,g,b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a,r,g,b) = (255,255,255,255)
        }
        self.init(.sRGB, red: Double(r)/255, green: Double(g)/255, blue: Double(b)/255, opacity: Double(a)/255)
    }
}
