// LearningInfoCardView.swift
import SwiftUI

struct LearningInfoCardView: View {
    var stats: LearningStats   // onTap 제거

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Label("학습 정보", systemImage: "chart.bar.fill")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                HStack(spacing: 6) {
                    Image(systemName: "flame.fill")
                    Text("\(stats.streakDays)일 연속")
                }
                .font(.caption.bold())
                .padding(.vertical, 6)
                .padding(.horizontal, 10)
                .background(Color.accentYellow.opacity(0.2))
                .foregroundColor(.accentYellow)
                .clipShape(Capsule())
            }

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("오늘 목표")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.85))
                    Spacer()
                    Text("\(stats.todayLearnedMinutes)m / \(stats.todayGoalMinutes)m")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white.opacity(0.15))
                            .frame(height: 10)
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.accentBlue)
                            .frame(width: max(10, geo.size.width * stats.todayProgress), height: 10)
                    }
                }
                .frame(height: 10)
            }

            HStack(spacing: 16) {
                MetricTile(title: "누적 단어", value: "\(stats.wordsLearnedTotal)", icon: "book.fill")
                MetricTile(title: "누적 시간", value: "\(stats.minutesLearnedTotal)m", icon: "clock.fill")
            }
        }
        .padding(16)
        .background(
            LinearGradient(
                colors: [Color.black.opacity(0.35), Color.black.opacity(0.2)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
        .cornerRadius(16)
        // 탭 영역 정확히 잡기 위해
        .contentShape(RoundedRectangle(cornerRadius: 16))
    }
}

private struct MetricTile: View {
    let title: String
    let value: String
    let icon: String
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .imageScale(.medium)
                .foregroundColor(.accentYellow)
                .frame(width: 26, height: 26)
                .background(Color.white.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 6))
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.caption).foregroundColor(.white.opacity(0.7))
                Text(value).font(.headline.bold()).foregroundColor(.white)
            }
            Spacer()
        }
        .padding(12)
        .background(Color.white.opacity(0.06))
        .cornerRadius(12)
    }
}
