import SwiftUI

/// Controls the visual appearance and layout of tablature rendering.
///
/// Use the `.tablatureStyle(_:)` view modifier or the `\.tablatureStyle`
/// environment value to customise how `TablatureView` draws its content.
public struct TablatureStyle: Sendable {

    // MARK: - Spacing

    /// Width of the string-label column on the left edge.
    public var labelColumnWidth: CGFloat

    /// Vertical distance between adjacent staff lines.
    public var stringSpacing: CGFloat

    /// Horizontal width of each measure.
    public var measureWidth: CGFloat

    /// Padding inside a measure to keep notes off bar lines.
    public var measureInset: CGFloat

    /// Stroke width of staff lines and bar lines.
    public var lineThickness: CGFloat

    /// Vertical padding above the top string and below the bottom string.
    public var verticalPadding: CGFloat

    // MARK: - Fonts

    /// Font for fret numbers.
    public var fretFont: Font

    /// Font for string labels.
    public var labelFont: Font

    // MARK: - Colors

    /// Color of fret number text.
    public var fretColor: Color

    /// Background color behind fret numbers (knocks out the staff line).
    /// When `nil`, a platform-adaptive default is used.
    public var fretBackgroundColor: Color?

    /// Color of string label text.
    public var labelColor: Color

    /// Color of staff lines and bar lines.
    public var lineColor: Color

    // MARK: - Defaults

    /// The default tablature style matching the original hardcoded values.
    public static let `default` = TablatureStyle()

    /// Creates a tablature style with sensible defaults.
    public init(
        labelColumnWidth: CGFloat = 30,
        stringSpacing: CGFloat = 20,
        measureWidth: CGFloat = 300,
        measureInset: CGFloat = 15,
        lineThickness: CGFloat = 1,
        verticalPadding: CGFloat = 10,
        fretFont: Font = .system(size: 14, weight: .bold, design: .monospaced),
        labelFont: Font = .system(size: 11, weight: .medium, design: .monospaced),
        fretColor: Color = .primary,
        fretBackgroundColor: Color? = nil,
        labelColor: Color = .secondary,
        lineColor: Color = .primary
    ) {
        self.labelColumnWidth = labelColumnWidth
        self.stringSpacing = stringSpacing
        self.measureWidth = measureWidth
        self.measureInset = measureInset
        self.lineThickness = lineThickness
        self.verticalPadding = verticalPadding
        self.fretFont = fretFont
        self.labelFont = labelFont
        self.fretColor = fretColor
        self.fretBackgroundColor = fretBackgroundColor
        self.labelColor = labelColor
        self.lineColor = lineColor
    }

    // MARK: - Resolved Colors

    /// The background color behind fret numbers, resolved from
    /// `fretBackgroundColor` or the platform default.
    public var resolvedFretBackgroundColor: Color {
        if let fretBackgroundColor { return fretBackgroundColor }
        #if canImport(UIKit)
        return Color(uiColor: .systemBackground)
        #elseif canImport(AppKit)
        return Color(nsColor: .windowBackgroundColor)
        #endif
    }

    // MARK: - Coordinate Helpers

    /// The height of the staff area (top string to bottom string).
    public func staffHeight(stringCount: Int) -> CGFloat {
        CGFloat(stringCount - 1) * stringSpacing
    }

    /// The total height including vertical padding.
    public func totalHeight(stringCount: Int) -> CGFloat {
        staffHeight(stringCount: stringCount) + 2 * verticalPadding
    }

    /// Converts a note's time position to an x coordinate within a measure.
    public func xPosition(for note: TabNote, in measure: TabMeasure) -> CGFloat {
        let usableWidth = measureWidth - 2 * measureInset
        guard measure.duration > 0 else { return measureInset }
        return measureInset + CGFloat(note.time / measure.duration) * usableWidth
    }

    /// Converts a note's string index to a y coordinate.
    /// String 0 (lowest pitch) is at the bottom; the highest string index is at the top.
    public func yPosition(for note: TabNote, stringCount: Int) -> CGFloat {
        verticalPadding + CGFloat(stringCount - 1 - note.string) * stringSpacing
    }
}

// MARK: - Environment

private struct TablatureStyleKey: EnvironmentKey {
    static let defaultValue = TablatureStyle.default
}

extension EnvironmentValues {
    /// The tablature style used by `TablatureView` and its children.
    public var tablatureStyle: TablatureStyle {
        get { self[TablatureStyleKey.self] }
        set { self[TablatureStyleKey.self] = newValue }
    }
}

extension View {
    /// Sets the tablature style for this view and its children.
    public func tablatureStyle(_ style: TablatureStyle) -> some View {
        environment(\.tablatureStyle, style)
    }
}
