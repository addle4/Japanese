import SwiftUI

struct FuriganaTextView: View {
    let units: [FuriganaUnit]

    var body: some View {
        HStack(alignment: .bottom, spacing: 2) {
            ForEach(0..<units.count, id: \.self) { index in
                let unit = units[index]
                VStack(spacing: 2) {
                    if let furigana = unit.furigana {
                        Text(furigana)
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                    }
                    Text(unit.text)
                        .font(.body)
                }
            }
        }
    }
}
