import SwiftUI

struct ProfileView: View {
    @State private var name: String = "환둥이"
    @State private var totalMinutes: Int = 94
    @State private var streakDays: Int = 5
    @State private var totalDays: Int = 9
    @State private var avatar: Image? = Image("profile") 

    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 20) {
            Text("프로필 설정")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.black)
                .padding(.top, 14)
            // 상단 배너
            Color(customHex: "#FFE3E3")
                .frame(height: 200)
                .ignoresSafeArea(edges: .top)

            ScrollView(showsIndicators: false) {
                
                    // 아바타 + 이름 카드 영역
                    VStack(spacing: 18) {
                        ZStack {
                            Circle()
                                .fill(Color(customHex: "#FFD6BA"))
                            if let avatar {
                                avatar
                                    .resizable()
                                    .scaledToFit()
                                    .padding(16)
                            } else {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .padding(22)
                                    .foregroundColor(.gray.opacity(0.6))
                            }
                        }
                        .frame(width: 120, height: 120)
                        .overlay(
                            Circle().stroke(Color.black.opacity(0.06), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.08), radius: 8, y: 4)

                        // 이름 + 연필
                        HStack(spacing: 8) {
                            Text(name)
                                .font(.system(size: 24, weight: .heavy))
                                .foregroundColor(.black)
                            Button {
                                // 이름 편집 로직 연결 (시트/알럿)
                            } label: {
                                Image(systemName: "pencil")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.gray)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.top, 28)

                    // 통계 3칸
                    StatsRow(
                        totalMinutes: totalMinutes,
                        streakDays: streakDays,
                        totalDays: totalDays
                    )
                    .padding(.horizontal, 20)

                    Spacer(minLength: 24)
                }
            }
        }
        .background(Color.white)
    }
}

// MARK: - 통계 3칸 컴포넌트
private struct StatsRow: View {
    let totalMinutes: Int
    let streakDays: Int
    let totalDays: Int

    var body: some View {
        HStack(spacing: 0) {
            StatItem(
                icon: "clock",
                title: "총 학습 시간",
                value: "\(totalMinutes)분"
            )
            Divider().frame(height: 44)
            StatItem(
                icon: "flame.fill",
                title: "연속 학습일",
                value: "\(streakDays)d"
            )
            Divider().frame(height: 44)
            StatItem(
                icon: "calendar",
                title: "누적 학습일",
                value: "\(totalDays)d"
            )
        }
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.06), radius: 6, y: 2)
        )
    }
}

private struct StatItem: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.gray.opacity(0.7))
                Text(title)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }
            Text(value)
                .font(.system(size: 22, weight: .heavy))
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 12)
    }
}

// MARK: - HEX Color 확장
extension Color {
    init(customHex hex: String) {
        let s = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: s.hasPrefix("#") ? String(s.dropFirst()) : s)
        var rgb: UInt64 = 0
        _ = scanner.scanHexInt64(&rgb)

        self.init(
            red: Double((rgb >> 16) & 0xFF) / 255.0,
            green: Double((rgb >> 8) & 0xFF) / 255.0,
            blue: Double(rgb & 0xFF) / 255.0
        )
    }
}

