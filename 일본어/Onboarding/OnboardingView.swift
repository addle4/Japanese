// OnboardingView.swift

import SwiftUI
import KakaoSDKUser
import GoogleSignIn
import FirebaseCore

struct OnboardingView: View {
    @AppStorage("hasLaunchedBefore") var hasLaunchedBefore = false
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var errorMessage = ""
    @State private var isLoggedIn = false
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Text("ようこそ!")
                .font(.system(size: 40, weight: .bold))
            
            Text("이 앱은 듣기부터 작문까지\n일본어를 단계별로 학습할 수 있어요.")
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding()
            
            if isLoading {
                ProgressView("로그인 중입니다...")
                    .padding()
            }
            
            Spacer()
            
            // MARK: - 카카오 로그인
            Button(action: handleKakaoLogin) {
                HStack {
                    Image(systemName: "message.fill")
                    Text("카카오로 시작하기")
                        .fontWeight(.bold)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.yellow)
                .foregroundColor(.black)
                .cornerRadius(10)
                .padding(.horizontal)
            }
            
            // MARK: - 구글 로그인
            Button(action: handleGoogleLogin) {
                HStack {
                    Image(systemName: "globe")
                    Text("구글로 시작하기")
                        .fontWeight(.bold)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
            }
            
            Spacer()
        }
        .padding()
        .alert("로그인 실패", isPresented: $showAlert) {
            Button("확인", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }.fullScreenCover(isPresented: $isLoggedIn) {
            MainView()
        }.onAppear {
#if DEBUG
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isLoggedIn = true
            }
#endif
        }
    }
    
    
    // MARK: - 카카오 로그인 처리
    private func handleKakaoLogin() {
        isLoading = true
        
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                handleLoginResult(error: error)
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                handleLoginResult(error: error)
            }
        }
    }
    
    // MARK: - 구글 로그인 처리
    private func handleGoogleLogin() {
        isLoading = true
        
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            showError("Firebase clientID가 없습니다.")
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            showError("루트 뷰 컨트롤러를 찾을 수 없습니다.")
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
            if let error = error {
                showError("구글 로그인 실패: \(error.localizedDescription)")
                return
            }
            
            print("✅ 구글 로그인 성공: \(result?.user.profile?.name ?? "알 수 없음")")
            completeLogin()
        }
    }
    
    // MARK: - 공통 로그인 결과 처리
    private func handleLoginResult(error: Error?) {
        if let error = error {
            showError("카카오 로그인 실패: \(error.localizedDescription)")
        } else {
            print("✅ 카카오 로그인 성공")
            completeLogin()
        }
    }
    
    private func completeLogin() {
        isLoading = false
        hasLaunchedBefore = true
        isLoggedIn = true
    }
    
    private func showError(_ message: String) {
        isLoading = false
        errorMessage = message
        showAlert = true
    }
}
