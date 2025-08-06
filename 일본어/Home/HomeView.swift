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
                    Color(red: 255 / 255, green: 220 / 255, blue: 230 / 255), // #CCBFE0
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
                    
                    // 임시 버튼
                    NavigationLink(destination: ConversationView()) {
                        Text("오늘의 회화")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentBlue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)

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
