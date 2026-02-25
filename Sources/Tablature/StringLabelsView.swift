import SwiftUI

/// A fixed column of string labels showing the tuning note name for each string.
/// Displayed at the left edge of the tablature, outside the scroll view.
struct StringLabelsView: View {
    @Environment(\.tablatureStyle) private var style

    /// The instrument whose tuning provides the labels.
    let instrument: StringInstrument

    var body: some View {
        ZStack {
            ForEach(0..<instrument.stringCount, id: \.self) { index in
                // Reversed: top line = highest string index, bottom = string 0
                let displayIndex = instrument.stringCount - 1 - index
                Text(instrument.stringNames[displayIndex])
                    .font(style.labelFont)
                    .foregroundStyle(style.labelColor)
                    .position(
                        x: style.labelColumnWidth / 2,
                        y: style.verticalPadding + CGFloat(index) * style.stringSpacing
                    )
            }
        }
        .frame(
            width: style.labelColumnWidth,
            height: style.totalHeight(stringCount: instrument.stringCount)
        )
    }
}
