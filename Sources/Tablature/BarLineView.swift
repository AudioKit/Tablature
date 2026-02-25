import SwiftUI

/// A vertical line drawn at measure boundaries in tablature.
struct BarLineView: View {
    @Environment(\.tablatureStyle) private var style

    /// Total height of the staff (from top string to bottom string).
    let height: CGFloat

    var body: some View {
        Rectangle()
            .fill(style.lineColor)
            .frame(width: style.lineThickness, height: height)
    }
}
