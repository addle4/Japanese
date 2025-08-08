// LearningOverviewView.swift
import SwiftUI

struct LearningOverviewView: View {
    var stats: LearningStats
    var onStartToday: (() -> Void)? = nil

    @State private var segment: Segment = .history
    enum Segment: String, CaseIterable { case history = "학습내역", allWords = "모든 어휘" }

    struct DayStat: Identifiable { let id = UUID(); let label: String; let newWords: Int; let correctness: Double }
    private let chartData: [DayStat] = [
        .init(label: "16일 전", newWords: 4, correctness: 0.62),
        .init(label: "2025-08-06", newWords: 7, correctness: 0.45),
        .init(label: "오늘", newWords: 6, correctness: 0.58),
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                // 상단 카드
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 12) {
                        Image(systemName: "person.circle.fill")
                            .resizable().frame(width: 40, height: 40)
                            .foregroundStyle(.white.opacity(0.9))
                        VStack(alignment: .leading, spacing: 2) {
                            Text("이쿠죠 \(stats.streakDays)일차")
                                .font(.subheadline).foregroundStyle(.white.opacity(0.9))
                            Text(stats.username)
                                .font(.title3).bold().foregroundStyle(.white)
                        }
                        Spacer()
                        Image(systemName: "ellipsis")
                            .font(.headline).foregroundStyle(.white.opacity(0.9))
                    }

                    HStack(spacing: 6) {
                        Circle().fill(Color.red).frame(width: 6, height: 6)
                        Text("JPY 100 = \(String(format: "%.2f", stats.jpyRate))원")
                            .font(.caption).foregroundStyle(.white.opacity(0.9))
                    }

                    Text("오늘의 학습").font(.subheadline).foregroundStyle(.white.opacity(0.95))

                    HStack(spacing: 16) {
                        ZStack {
                            Circle().stroke(.white.opacity(0.25), lineWidth: 10)
                            Circle()
                                .trim(from: 0, to: stats.todayProgress)
                                .stroke(Color.accentBlue, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                                .rotationEffect(.degrees(-90))
                            Text("\(Int(stats.todayProgress * 100))%")
                                .font(.headline).foregroundStyle(.white)
                        }
                        .frame(width: 96, height: 96)

                        VStack(alignment: .leading, spacing: 12) {
                            Button {
                                onStartToday?()
                            } label: {
                                HStack {
                                    Image(systemName: "play.fill")
                                    Text("시작하기").fontWeight(.semibold)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.white.opacity(0.9))
                                .foregroundColor(.black)
                                .cornerRadius(12)
                            }

                            Text("\(stats.todayLearnedMinutes)분 / \(stats.todayGoalMinutes)분")
                                .font(.caption).foregroundStyle(.white.opacity(0.8))
                        }
                    }
                    .padding(.top, 6)
                }
                .padding(16)
                .background(
                    LinearGradient(
                        colors: [
                            Color(red: 255/255, green: 220/255, blue: 230/255),
                            Color(red: 255/255, green: 220/255, blue: 230/255).opacity(0.6)
                        ],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))

                // 4칸 지표
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                    StatTile(icon: "trophy.fill",  title: "학습 달성률", value: stats.todayProgress == 0 ? "-" : "\(Int(stats.todayProgress*100))%")
                    StatTile(icon: "heart.fill",   title: "총 학습 문제", value: "\(stats.totalProblems)개")
                    StatTile(icon: "clock.fill",   title: "오늘 학습 시간", value: "\(stats.todayLearnedMinutes)분")
                    StatTile(icon: "timer",        title: "총 학습 시간", value: "\(stats.minutesLearnedTotal)분")
                }

                // segmented + 범례
                VStack(spacing: 12) {
                    Picker("", selection: $segment) {
                        ForEach(Segment.allCases, id: \.self) { s in
                            Text(s.rawValue).tag(s)
                        }
                    }
                    .pickerStyle(.segmented)

                    HStack(spacing: 14) {
                        Legend(color: Color.red.opacity(0.6), label: "새로 배운 단어")
                        Legend(color: Color.red.opacity(0.3), label: "복습 진행")
                        Legend(color: .gray.opacity(0.8), label: "학습 정답률")
                        Spacer()
                    }
                    .font(.caption)
                }

                // 그래프
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                        .shadow(radius: 2, y: 1)

                    VStack(spacing: 12) {
                        GeometryReader { geo in
                            let maxBar = max(chartData.map { $0.newWords }.max() ?? 1, 1)
                            let maxHeight = geo.size.height - 24

                            ZStack {
                                Path { path in
                                    for (i, d) in chartData.enumerated() {
                                        let x = geo.size.width * (CGFloat(i) / CGFloat(max(chartData.count-1, 1)))
                                        let y = maxHeight * (1 - CGFloat(d.correctness)) + 12
                                        if i == 0 { path.move(to: CGPoint(x: x, y: y)) }
                                        else { path.addLine(to: CGPoint(x: x, y: y)) }
                                    }
                                }
                                .stroke(.gray, style: StrokeStyle(lineWidth: 2, lineJoin: .round))

                                ForEach(Array(chartData.enumerated()), id: \.offset) { i, d in
                                    let x = geo.size.width * (CGFloat(i) / CGFloat(max(chartData.count-1, 1)))
                                    let y = maxHeight * (1 - CGFloat(d.correctness)) + 12
                                    Circle().fill(.gray)
                                        .frame(width: 6, height: 6)
                                        .position(x: x, y: y)
                                }

                                HStack(alignment: .bottom, spacing: 22) {
                                    ForEach(chartData) { d in
                                        let h = maxHeight * CGFloat(d.newWords) / CGFloat(maxBar)
                                        ZStack(alignment: .bottom) {
                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(Color.red.opacity(0.25))
                                                .frame(width: 20, height: h * 0.6)
                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(Color.red.opacity(0.6))
                                                .frame(width: 20, height: h)
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                                .padding(.horizontal, 28)
                                .padding(.bottom, 18)
                            }
                        }
                        .frame(height: 180)

                        HStack {
                            ForEach(chartData) { d in
                                Text(d.label).font(.caption2).foregroundStyle(.gray)
                                Spacer()
                            }
                        }
                        .padding(.horizontal, 28)
                    }
                    .padding(.vertical, 12)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 260)
            }
            .padding(16)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) { Text("어휘 학습 정보").font(.headline) }
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}

private struct StatTile: View {
    let icon: String; let title: String; let value: String
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .frame(width: 28, height: 28)
                .background(Color.accentYellow.opacity(0.25))
                .clipShape(RoundedRectangle(cornerRadius: 6))
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.caption).foregroundStyle(.secondary)
                Text(value).font(.headline)
            }
            Spacer()
        }
        .padding(12)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
    }
}

private struct Legend: View {
    let color: Color; let label: String
    var body: some View {
        HStack(spacing: 6) {
            Circle().fill(color).frame(width: 8, height: 8)
            Text(label)
        }
    }
}
