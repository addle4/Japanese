import SwiftUI

// MARK: - 공통 버튼
struct AppButton: View {
    let title: String
    var backgroundColor: Color = .accentBlue
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(backgroundColor)
                .foregroundColor(.white)
                .cornerRadius(15)
        }
        .padding(.horizontal)
        .padding(.bottom, 10)
    }
}


