import SwiftUI

struct MainView: View {
    @State private var selectedTab = 0
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.darkBackground)
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {

               TabView(selection: $selectedTab) {
                   // 홈
                   NavigationStack {
                       HomeView()
                   }
                   .tabItem { Label("홈", systemImage: "house") }
                   .tag(0)

                   // 단어장
                   NavigationStack {
                       VocabularyView()
                   }
                   .tabItem { Label("단어장", systemImage: "book") }
                   .tag(1)

                   // 복습
                   NavigationStack {
                       ReviewView()
                   }
                   .tabItem { Label("복습", systemImage: "flame") }
                   .tag(2)

                   // 프로필
                   NavigationStack {
                       ProfileView()
                   }
                   .tabItem { Label("프로필", systemImage: "person.crop.circle") }
                   .tag(3)
               }
               // ✅ 외부(예: KeywordsScreen)에서 보낸 탭 전환 노티만 처리
               .onReceive(NotificationCenter.default.publisher(for: AppNotification.switchTab)) { note in
                   if let idx = note.userInfo?["index"] as? Int {
                       withAnimation { selectedTab = idx }
                   }
               }
        .accentColor(.white)
    }
}
