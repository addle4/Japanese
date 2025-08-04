import SwiftUI

struct HomeView: View {
    @State private var isShowingLearningView = false

    init() {
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithOpaqueBackground()
        navAppearance.backgroundColor = UIColor(Color.darkBackground)
        navAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
    }

    var body: some View {
        ZStack {
            Color.darkBackground.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 30) {
                    HeaderView(username: "사용자", streakCount: 3)

                    LessonCardView {
                        isShowingLearningView = true
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
