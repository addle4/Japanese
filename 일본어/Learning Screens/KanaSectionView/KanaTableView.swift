import SwiftUI

// MARK: - 히라가나/가타카나 표 뷰 (최적화 버전)
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
                            Button {
                                selectedCharacter = char
                            } label: {
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
        }
        .sheet(item: $selectedCharacter) { character in
            KanaDetailView(character: character) {
                selectedCharacter = nil
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

