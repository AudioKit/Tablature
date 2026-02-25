import SwiftUI

/// Canvas overlay that draws articulation annotations (bends, hammer-ons,
/// pull-offs, slides) on top of fret numbers within a measure.
struct ArticulationOverlayView: View {
    @Environment(\.tablatureStyle) private var style

    let measure: TabMeasure
    let stringCount: Int

    var body: some View {
        Canvas { context, size in
            // Bend indicators
            for note in measure.notes {
                guard case .bend(let semitones) = note.articulation else { continue }
                let x = style.xPosition(for: note, in: measure)
                let y = style.yPosition(for: note, stringCount: stringCount)
                drawBend(in: &context, at: CGPoint(x: x, y: y), semitones: semitones)
            }

            // Between-note articulations (H, P, slide)
            for pair in measure.articulationPairs {
                let x1 = style.xPosition(for: pair.from, in: measure)
                let x2 = style.xPosition(for: pair.to, in: measure)
                let y = style.yPosition(for: pair.to, stringCount: stringCount)

                switch pair.articulation {
                case .hammerOn:
                    drawHammerPull(in: &context, from: x1, to: x2, y: y, label: "H")
                case .pullOff:
                    drawHammerPull(in: &context, from: x1, to: x2, y: y, label: "P")
                case .slideUp:
                    drawSlide(in: &context, from: x1, to: x2, y: y, up: true)
                case .slideDown:
                    drawSlide(in: &context, from: x1, to: x2, y: y, up: false)
                default:
                    break
                }
            }
        }
        .frame(
            width: style.measureWidth,
            height: style.totalHeight(stringCount: stringCount)
        )
        .allowsHitTesting(false)
    }

    // MARK: - Bend Drawing

    private func drawBend(in context: inout GraphicsContext, at point: CGPoint, semitones: Double) {
        let startX = point.x + 10
        let curveEndX = startX + 14
        let curveHeight: CGFloat = min(10, style.stringSpacing * 0.5)
        let endY = point.y - curveHeight

        // Curved line to the right of the fret number, curving upward
        var path = Path()
        path.move(to: CGPoint(x: startX, y: point.y))
        path.addQuadCurve(
            to: CGPoint(x: curveEndX, y: endY),
            control: CGPoint(x: curveEndX, y: point.y)
        )
        context.stroke(path, with: .color(style.fretColor), lineWidth: 1.5)

        // Filled arrowhead at the top of the curve
        var arrowHead = Path()
        arrowHead.move(to: CGPoint(x: curveEndX - 3, y: endY + 4))
        arrowHead.addLine(to: CGPoint(x: curveEndX, y: endY))
        arrowHead.addLine(to: CGPoint(x: curveEndX + 3, y: endY + 4))
        arrowHead.closeSubpath()
        context.fill(arrowHead, with: .color(style.fretColor))

        // Label to the right of the arrowhead
        let label = context.resolve(
            Text(bendLabel(semitones: semitones))
                .font(style.labelFont)
                .foregroundColor(style.fretColor)
        )
        context.draw(label, at: CGPoint(x: curveEndX + 14, y: endY), anchor: .leading)
    }

    // MARK: - Hammer-On / Pull-Off Drawing

    private func drawHammerPull(in context: inout GraphicsContext, from x1: CGFloat, to x2: CGFloat, y: CGFloat, label: String) {
        let midX = (x1 + x2) / 2

        // Background knockout so the letter is readable over the staff line
        let bgSize: CGFloat = 12
        let bgRect = CGRect(x: midX - bgSize / 2, y: y - bgSize / 2, width: bgSize, height: bgSize)
        context.fill(Path(bgRect), with: .color(style.resolvedFretBackgroundColor))

        // Letter on the string line between the two notes
        let text = context.resolve(
            Text(label)
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundColor(style.fretColor)
        )
        context.draw(text, at: CGPoint(x: midX, y: y))
    }

    // MARK: - Slide Drawing

    private func drawSlide(in context: inout GraphicsContext, from x1: CGFloat, to x2: CGFloat, y: CGFloat, up: Bool) {
        let inset: CGFloat = 10
        let verticalOffset: CGFloat = 5

        // Diagonal line between notes
        var line = Path()
        if up {
            line.move(to: CGPoint(x: x1 + inset, y: y + verticalOffset))
            line.addLine(to: CGPoint(x: x2 - inset, y: y - verticalOffset))
        } else {
            line.move(to: CGPoint(x: x1 + inset, y: y - verticalOffset))
            line.addLine(to: CGPoint(x: x2 - inset, y: y + verticalOffset))
        }
        context.stroke(line, with: .color(style.fretColor), lineWidth: 1.5)
    }
}

// MARK: - Bend Label

/// Converts a bend amount in semitones to a standard tablature label.
func bendLabel(semitones: Double) -> String {
    switch semitones {
    case 0.5: return "1/4"
    case 1.0: return "1/2"
    case 2.0: return "full"
    case 3.0: return "1 1/2"
    default: return String(format: "%g", semitones)
    }
}

// MARK: - TabMeasure Articulation Helpers

extension TabMeasure {
    /// Pairs of consecutive notes on the same string where the second note
    /// has a between-note articulation (hammer-on, pull-off, or slide).
    var articulationPairs: [(from: TabNote, to: TabNote, articulation: Articulation)] {
        let byString = Dictionary(grouping: sortedNotes) { $0.string }
        var pairs: [(from: TabNote, to: TabNote, articulation: Articulation)] = []
        for (_, notes) in byString {
            for i in 1..<notes.count {
                guard let art = notes[i].articulation else { continue }
                switch art {
                case .hammerOn, .pullOff, .slideUp, .slideDown:
                    pairs.append((from: notes[i - 1], to: notes[i], articulation: art))
                default:
                    break
                }
            }
        }
        return pairs
    }
}
