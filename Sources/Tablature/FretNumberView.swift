import SwiftUI

/// Renders a fret number as text with an opaque knockout background
/// that hides the staff line behind it — standard tablature convention.
struct FretNumberView: View {
    @Environment(\.tablatureStyle) private var style

    /// The fret number to display.
    let fret: Int

    /// The string index this fret number belongs to (for accessibility).
    var string: Int = 0

    var body: some View {
        Text("\(fret)")
            .font(style.fretFont)
            .foregroundStyle(style.fretColor)
            .padding(.horizontal, 2)
            .background(style.resolvedFretBackgroundColor)
            .accessibilityLabel("Fret \(fret) on string \(string + 1)")
    }
}
