// KanaTableView.swift
import SwiftUI
import UIKit

struct KanaTableView: View {
    let title: String
    let gridData: [KanaGridItem]
    @State private var selectedCharacter: KanaCharacter?
    private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 5)

    var body: some View {
        ZStack {
            Color.darkBackground
                .ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: true) {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(gridData) { item in
                        switch item {
                        case .character(let char):
                            Button(action: {
                                withAnimation(.none) {
                                    selectedCharacter = char
                                }
                            }) {
                                KanaCellView(character: char)
                            }
                        case .empty:
                            Color.clear
                                .frame(height: 80)
                        }
                    }
                }
                .padding()
            }
            .scrollBounceBehavior(.basedOnSize) // iOS17+: 콘텐츠가 클 때만 바운스됩니다.

            if let character = selectedCharacter {
                ZStack {
                    Color.black.opacity(0.6)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.none) {
                                selectedCharacter = nil
                            }
                        }

                    KanaDetailView(character: character) {
                        withAnimation(.none) {
                            selectedCharacter = nil
                        }
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        // .onAppear 블록을 제거합니다.
    }
}
