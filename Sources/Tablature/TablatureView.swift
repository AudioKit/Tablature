import SwiftUI

/// A SwiftUI view that renders a complete tablature passage from a `TabSequence`.
///
/// The view displays a fixed column of string labels on the left and a horizontally
/// scrollable area containing staff lines, fret numbers, and measure bar lines.
///
/// ```swift
/// TablatureView(sequence: .smokeOnTheWater)
/// ```
public struct TablatureView: View {
    @Environment(\.tablatureStyle) private var style

    /// The tablature sequence to render.
    let sequence: TabSequence

    /// Creates a tablature view for the given sequence.
    ///
    /// - Parameter sequence: The tablature passage to render.
    public init(sequence: TabSequence) {
        self.sequence = sequence
    }

    public var body: some View {
        let instrument = sequence.instrument
        let staffHeight = style.staffHeight(stringCount: instrument.stringCount)
        let totalHeight = style.totalHeight(stringCount: instrument.stringCount)
        let totalMeasureWidth = CGFloat(sequence.measures.count) * style.measureWidth

        HStack(alignment: .top, spacing: 0) {
            // Fixed string labels column
            StringLabelsView(instrument: instrument)
                .padding(.leading, 4)

            // Scrollable tablature area
            ScrollView(.horizontal, showsIndicators: true) {
                ZStack(alignment: .topLeading) {
                    // Staff lines spanning full width
                    StaffLinesView(stringCount: instrument.stringCount)
                        .frame(width: totalMeasureWidth)

                    // Leading bar line
                    BarLineView(height: staffHeight)
                        .position(x: 0, y: style.verticalPadding + staffHeight / 2)

                    // Measures with notes and trailing bar lines
                    HStack(alignment: .top, spacing: 0) {
                        ForEach(Array(sequence.measures.enumerated()), id: \.element.id) { _, measure in
                            MeasureView(
                                measure: measure,
                                stringCount: instrument.stringCount
                            )
                        }
                    }
                }
                .frame(width: totalMeasureWidth, height: totalHeight)
            }
        }
        .frame(height: totalHeight)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Tablature: \(sequence.measures.flatMap(\.notes).count) notes across \(sequence.measures.count) measures")
    }
}
