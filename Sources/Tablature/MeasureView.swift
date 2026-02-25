import SwiftUI

/// Renders all notes within a single measure plus a trailing bar line.
/// Uses coordinate mapping to position fret numbers at the correct string and time location.
struct MeasureView: View {
    @Environment(\.tablatureStyle) private var style

    /// The measure to render.
    let measure: TabMeasure

    /// Number of strings on the instrument.
    let stringCount: Int

    var body: some View {
        let staffHeight = style.staffHeight(stringCount: stringCount)

        ZStack(alignment: .topLeading) {
            ForEach(measure.notes) { note in
                FretNumberView(fret: note.fret, string: note.string)
                    .position(
                        x: style.xPosition(for: note, in: measure),
                        y: style.yPosition(for: note, stringCount: stringCount)
                    )
            }

            // Articulation annotations (bends, hammer-ons, pull-offs, slides)
            ArticulationOverlayView(measure: measure, stringCount: stringCount)

            // Trailing bar line at the right edge
            BarLineView(height: staffHeight)
                .position(
                    x: style.measureWidth,
                    y: style.verticalPadding + staffHeight / 2
                )
        }
        .frame(
            width: style.measureWidth,
            height: style.totalHeight(stringCount: stringCount)
        )
    }
}
