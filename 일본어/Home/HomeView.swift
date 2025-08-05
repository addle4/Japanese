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
