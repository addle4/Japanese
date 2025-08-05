import SwiftUI

struct HomeView: View {
    @State private var isShowingLearningView = false

    init() {
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithTransparentBackground()
        navAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
    }

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 204 / 255, green: 191 / 255, blue: 224 / 255), // #CCBFE0
                    .white
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    HeaderView(username: "사용자", streakCount: 3)

                    // ✅ 오늘의 학습 제목
                    HStack(spacing: 4) {
                        Image(systemName: "book.fill")
                            .foregroundColor(Color(hex: "#6932BE"))
                        Text("오늘의 학습")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(hex: "#222222"))
                    }

                    // ✅ 학습 카드
                    LessonCardView {
                        isShowingLearningView = true
                    }

                    // ✅ 오늘의 회화 카드
                    ConversationCardView {
                        isShowingLearningView = true // 임시로 러닝뷰
                        
                    }

                    KanaSectionView()

                    Spacer()
                }
                .padding()
            }
        }
        .navigationTitle("홈")
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $isShowingLearningView) {
            LearningFlowView()
        }
    }
}
