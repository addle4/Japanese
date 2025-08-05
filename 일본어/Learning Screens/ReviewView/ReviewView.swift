import SwiftUI

struct ReviewView: View {
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

            VStack(spacing: 20) {
                Text("복습 모드")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text("기억이 희미해진 단어와 표현들을 복습해요.")
                    .foregroundColor(.white.opacity(0.7))

                Spacer()

                VStack(spacing: 10) {
                    Text("오늘 복습할 항목이 5개 있어요!")
                        .foregroundColor(.accentYellow)

                    // 이 구조는 Button 에 Modifier 를 적용하는 방식인데, 이 경우 버튼 자체의 터치 영역이 텍스트(“복습 시작”) 크기만큼만 존재하고, 배경 색은 그 외부에 씌워지기 때문에 전체 영역이 클릭되지 않음
//                    Button("복습 시작") {
//                        // 복습 모드 진입
//                    }
//                    .padding()
//                    .frame(maxWidth: .infinity)
//                    .background(Color.accentBlue)
//                    .foregroundColor(.white)
//                    .cornerRadius(12)
//                    .padding(.horizontal)
                    
                    // Button("텍스트") 대신, 전체 뷰를 래핑하는 방식으로 변경.
                    Button(action: {
                        // 복습 모드 진입
                    }) {
                        Text("복습 시작")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentBlue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("복습")
        .navigationBarTitleDisplayMode(.inline)
    }
}
