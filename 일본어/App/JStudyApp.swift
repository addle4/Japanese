import SwiftUI

@main
struct JStudyApp: App {
    // 온보딩 여부 저장
    @AppStorage("hasLaunchedBefore") var hasLaunchedBefore = false
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        // 개발 중 온보딩 항상 보이게
        hasLaunchedBefore = false
    }

    var body: some Scene {
        WindowGroup {
            if hasLaunchedBefore {
                NavigationStack{
                    MainView()
                }
            } else {
                OnboardingView()
            }
        }
    }
}
