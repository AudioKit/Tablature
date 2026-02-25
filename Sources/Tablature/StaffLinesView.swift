import SwiftUI

/// Draws horizontal staff lines across the full width of the tablature using Canvas.
/// One line per string, evenly spaced.
struct StaffLinesView: View {
    @Environment(\.tablatureStyle) private var style

    /// Number of strings on the instrument.
    let stringCount: Int

    var body: some View {
        Canvas { context, size in
            for i in 0..<stringCount {
                let y = style.verticalPadding + CGFloat(i) * style.stringSpacing
                let path = Path { p in
                    p.move(to: CGPoint(x: 0, y: y))
                    p.addLine(to: CGPoint(x: size.width, y: y))
                }
                context.stroke(path, with: .color(style.lineColor), lineWidth: style.lineThickness)
            }
        }
        .frame(height: style.totalHeight(stringCount: stringCount))
    }
}
