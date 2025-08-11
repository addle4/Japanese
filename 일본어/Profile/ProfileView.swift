import SwiftUI

struct ProfileView: View {
    @State private var name: String = "환둥이"
    @State private var totalMinutes: Int = 94
    @State private var streakDays: Int = 5
    @State private var totalDays: Int = 9
    @State private var avatar: Image? = Image("profile")
    
    // 캘린더 색상 상수
    private let headerColor = Color(customHex: "#FFD6D6")
    private let panelColor  = Color(customHex: "#ECECEC")
    private let learnedDot  = Color(customHex: "#FFD6D6")
    private let normalDot   = Color(customHex: "#CFCFCF")
    private let todayDot    = Color(customHex: "#BDBDBD")

    var body: some View {
        VStack(spacing: 0) {
            Text("프로필 설정")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.black)
                .padding(.top, 14)

            ZStack(alignment: .bottom) {
                Color(customHex: "#FFE3E3")
                    .frame(height: 160)
                    .ignoresSafeArea(edges: .top)

                ZStack {
                    Circle()
                        .fill(Color(customHex: "#FFD6BA"))
                    if let avatar {
                        avatar
                            .resizable()
                            .scaledToFit()
                            .padding(3)
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .padding(24)
                            .foregroundColor(.gray.opacity(0.6))
                    }
                }
                .frame(width: 120, height: 120)
                .overlay(
                    Circle().stroke(Color.black.opacity(0.06), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
                .offset(y: 40)
            }
            .padding(.bottom, 40)

            HStack(spacing: 8) {
                Text(name)
                    .font(.system(size: 24, weight: .heavy))
                    .foregroundColor(.black)
                Button {
                } label: {
                    Image(systemName: "pencil")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.gray)
                }
                .buttonStyle(.plain)
            }
            .padding(.top, 8)

            StatsRow(
                totalMinutes: totalMinutes,
                streakDays: streakDays,
                totalDays: totalDays
            )
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            // 예시: 캘린더 뷰 추가 (원하는 위치에)
            CalendarView(
                headerColor: headerColor,
                panelColor: panelColor,
                learnedDot: learnedDot,
                normalDot: normalDot,
                todayDot: todayDot
            )
            .padding(.top, 20)

            Spacer()
        }
        .background(Color.white)
        .navigationBarTitle("프로필 설정", displayMode: .inline)
    }
}

// MARK: - 통계 3칸 컴포넌트 (세로 정렬)
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

            Divider()
                .frame(width: 1, height: 72)
                .background(Color.black.opacity(0.1))

            StatItem(
                icon: "flame.fill",
                title: "연속 학습일",
                value: "\(streakDays)d"
            )

            Divider()
                .frame(width: 1, height: 72)
                .background(Color.black.opacity(0.1))

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
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.gray.opacity(0.6))

            Text(title)
                .font(.system(size: 14))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)

            Text(value)
                .font(.system(size: 22, weight: .heavy))
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 12)
    }
}

// MARK: - 캘린더 뷰 예시
struct CalendarView: View {
    let headerColor: Color
    let panelColor: Color
    let learnedDot: Color
    let normalDot: Color
    let todayDot: Color

    var body: some View {
        VStack(spacing: 0) {
            Text("8月")
                .font(.system(size: 24, weight: .bold))
                .frame(maxWidth: .infinity)
                .padding()
                .background(headerColor)
                .cornerRadius(8, corners: [.topLeft, .topRight])
            
            VStack {
                Text("여기에 1234556454날짜들")
                    .padding()
            }
            .frame(maxWidth: .infinity)
            .background(panelColor)
            .cornerRadius(8, corners: [.bottomLeft, .bottomRight])
        }
        .padding(.horizontal)
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

// MARK: - 모서리별 코너 적용 확장
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
