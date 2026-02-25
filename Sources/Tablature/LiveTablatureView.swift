import SwiftUI

/// A real-time scrolling tablature view that renders incoming notes as they
/// are added to a `LiveTablatureModel`. Notes appear at the right edge and
/// scroll left as time advances.
///
/// Uses `TimelineView(.animation)` to drive smooth frame-rate updates and
/// `Canvas` for efficient rendering.
///
/// ```swift
/// let model = LiveTablatureModel(instrument: .guitar)
/// LiveTablatureView(model: model)
/// ```
public struct LiveTablatureView: View {
    @ObservedObject var model: LiveTablatureModel
    @Environment(\.tablatureStyle) private var style

    /// Creates a live tablature view driven by the given model.
    ///
    /// - Parameter model: The live tablature model providing notes and timing.
    public init(model: LiveTablatureModel) {
        self.model = model
    }

    public var body: some View {
        let stringCount = model.instrument.stringCount
        let totalHeight = style.totalHeight(stringCount: stringCount)

        HStack(alignment: .top, spacing: 0) {
            StringLabelsView(instrument: model.instrument)
                .padding(.leading, 4)

            TimelineView(.animation) { timeline in
                let now = timeline.date.timeIntervalSince(model.startDate)

                Canvas { context, size in
                    drawStaffLines(in: &context, size: size, stringCount: stringCount)
                    drawNotes(in: &context, size: size, stringCount: stringCount, currentTime: now)
                    drawCursor(in: &context, size: size, stringCount: stringCount)
                }
                .frame(height: totalHeight)
            }
        }
        .frame(height: totalHeight)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Live tablature")
        .accessibilityValue("\(model.notes.count) notes")
    }

    // MARK: - Staff Lines

    private func drawStaffLines(in context: inout GraphicsContext, size: CGSize, stringCount: Int) {
        for i in 0..<stringCount {
            let y = style.verticalPadding + CGFloat(i) * style.stringSpacing
            var path = Path()
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: size.width, y: y))
            context.stroke(path, with: .color(style.lineColor), lineWidth: style.lineThickness)
        }
    }

    // MARK: - Notes

    private func drawNotes(in context: inout GraphicsContext, size: CGSize, stringCount: Int, currentTime: TimeInterval) {
        let timeWindow = model.timeWindow
        guard timeWindow > 0 else { return }

        for note in model.notes {
            let age = currentTime - note.time
            guard age >= 0, age <= timeWindow else { continue }

            let x = size.width * CGFloat(1.0 - age / timeWindow)
            let y = style.verticalPadding + CGFloat(stringCount - 1 - note.string) * style.stringSpacing

            if note.articulation == .pitchBendArrow {
                drawPitchBendArrow(in: &context, at: CGPoint(x: x, y: y))
            } else {
                drawFretNumber(in: &context, fret: note.fret, at: CGPoint(x: x, y: y))
            }
        }
    }

    private func drawFretNumber(in context: inout GraphicsContext, fret: Int, at point: CGPoint) {
        let text = context.resolve(
            Text("\(fret)")
                .font(style.fretFont)
                .foregroundColor(style.fretColor)
        )
        let textSize = text.measure(in: CGSize(width: 100, height: 100))

        // Knockout background
        let bgRect = CGRect(
            x: point.x - textSize.width / 2 - 2,
            y: point.y - textSize.height / 2,
            width: textSize.width + 4,
            height: textSize.height
        )
        context.fill(Path(bgRect), with: .color(style.resolvedFretBackgroundColor))

        // Fret number
        context.draw(text, at: point)
    }

    private func drawPitchBendArrow(in context: inout GraphicsContext, at point: CGPoint) {
        let arrowHeight: CGFloat = min(14, style.stringSpacing * 0.7)
        let arrowWidth: CGFloat = 6

        // Vertical line from string up
        var stem = Path()
        stem.move(to: point)
        stem.addLine(to: CGPoint(x: point.x, y: point.y - arrowHeight))
        context.stroke(stem, with: .color(style.fretColor), lineWidth: 1.5)

        // Arrowhead
        let tipY = point.y - arrowHeight
        var head = Path()
        head.move(to: CGPoint(x: point.x - arrowWidth / 2, y: tipY + 4))
        head.addLine(to: CGPoint(x: point.x, y: tipY))
        head.addLine(to: CGPoint(x: point.x + arrowWidth / 2, y: tipY + 4))
        head.closeSubpath()
        context.fill(head, with: .color(style.fretColor))
    }

    // MARK: - Cursor

    private func drawCursor(in context: inout GraphicsContext, size: CGSize, stringCount: Int) {
        let cursorX = size.width - 1
        let topY = style.verticalPadding
        let bottomY = style.verticalPadding + style.staffHeight(stringCount: stringCount)

        var path = Path()
        path.move(to: CGPoint(x: cursorX, y: topY))
        path.addLine(to: CGPoint(x: cursorX, y: bottomY))
        context.stroke(path, with: .color(style.fretColor.opacity(0.4)), lineWidth: 1)
    }
}
