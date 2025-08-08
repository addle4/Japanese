import SwiftUI

struct MainView: View {
    @State private var selectedTab = 0
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.white)
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("홈")
            }
            .tag(0)
            
            VocabularyView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("단어장")
                }
                .tag(1)
            
            ReviewView()
                .tabItem {
                    Image(systemName: "flame.fill")
                    Text("복습")
                }
                .tag(2)
            
            ProfileView()

                .tabItem {
                    Image(systemName: "person.fill")
                    Text("프로필")
                }
                .tag(3)
        }
        .accentColor(.blue)
    }
}
