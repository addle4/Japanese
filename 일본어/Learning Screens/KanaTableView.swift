// KanaTableView.swift
import SwiftUI

// MARK: - 히라가나/가타카나 표 뷰 (스크롤 바운스 제거)
struct KanaTableView: View {
    let title: String
    let gridData: [KanaGridItem]
    
    @State private var selectedCharacter: KanaCharacter?

    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 5)

    var body: some View {
        ZStack {
            Color.darkBackground.ignoresSafeArea()
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(gridData) { item in
                        switch item {
                        case .character(let char):
                            Button(action: {
                                withAnimation(.spring()) {
                                    selectedCharacter = char
                                }
                            }) {
                                KanaCellView(character: char)
                            }
                        case .empty:
                            Rectangle()
                                .fill(Color.clear)
                                .frame(height: 80)
                        }
                    }
                }
                .padding()
            }
           // 스크롤이 콘텐츠 끝에 도달했을 때 튕기는 효과 제거
            
            if let character = selectedCharacter {
                Color.black.opacity(0.6)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation { selectedCharacter = nil }
                    }
                
                KanaDetailView(character: character) {
                    withAnimation { selectedCharacter = nil }
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
