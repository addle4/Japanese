// JStudyApp.swift
// SwiftUI App 엔트리 + Scene 단 openURL 보강

import SwiftUI
import KakaoSDKAuth
import GoogleSignIn
import FirebaseCore

@main
struct JStudyApp: App {
    @AppStorage("hasLaunchedBefore") var hasLaunchedBefore = false
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        // 개발 중엔 항상 온보딩을 보이게 강제
        hasLaunchedBefore = false
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if hasLaunchedBefore {
                    NavigationStack {
                        MainView()
                    }
                } else {
                    OnboardingView()
                }
            }
            // Scene 단에서도 URL 을 한 번 더 받아 Kakao/Google 처리 (보강용)
            .onOpenURL { url in
                // Kakao
                if AuthApi.isKakaoTalkLoginUrl(url) {
                    _ = AuthController.handleOpenUrl(url: url)
                    return
                }
                // Google
                if GIDSignIn.sharedInstance.handle(url) {
                    return
                }
            }
        }
    }
}
