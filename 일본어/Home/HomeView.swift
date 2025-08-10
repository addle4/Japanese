import SwiftUI

struct HomeView: View {
    @State private var isShowingLearningView = false
    @State private var stats = LearningStats.preview   // 실제 데이터 연결 전 임시
    
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
                    
                    
                    // 학습 정보 카드 → 탭하면 상세 화면
                    NavigationLink {
                        LearningOverviewView(stats: stats, onStartToday: { isShowingLearningView = true })
                    } label: {
                        LearningInfoCardView(stats: stats)   // onTap 파라미터 제거된 버전
                    }
                    .buttonStyle(.plain) // 선택 사항
                    
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
        .navigationTitle("홈") // 공백 하나
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $isShowingLearningView) {
            LearningFlowView()
        }
    }
}
