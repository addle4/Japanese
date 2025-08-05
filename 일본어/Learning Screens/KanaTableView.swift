import SwiftUI

struct KanaTableView: View {
    let title: String
    let gridData: [KanaGridItem]

    @State private var selectedCharacter: KanaCharacter?

    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 5)

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(gridData) { item in
                    switch item {
                    case .character(let char):
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
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

            Spacer().frame(height: 100) // 바운스 유도
        }
        .background(Color.darkBackground.ignoresSafeArea())
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .overlay(
            Group {
                if let character = selectedCharacter {
                    ZStack {
                        Color.black.opacity(0.6)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation {
                                    selectedCharacter = nil
                                }
                            }

                        KanaDetailView(character: character) {
                            withAnimation {
                                selectedCharacter = nil
                            }
                        }
                        .transition(.scale.combined(with: .opacity))
                    }
                }
            }
        )
    }
}

