import Foundation

/// Defines a stringed instrument by its tuning and physical properties.
///
/// Each instrument has an array of MIDI note numbers representing the open-string pitches.
/// String index 0 corresponds to the bottom tablature line (the string physically closest
/// to the player), which is typically the lowest-pitched string. For re-entrant tunings
/// (e.g. ukulele), pitch order may be non-monotonic.
public struct StringInstrument: Identifiable, Equatable, Hashable, Codable, Sendable {
    /// A stable identifier for this instrument (e.g. "guitar", "bass5String").
    public let id: String

    /// Human-readable display name (e.g. "Guitar", "Bass 5-String").
    public let name: String

    /// MIDI note numbers for each open string, ordered from bottom tablature line (index 0)
    /// to top tablature line.
    public let tuning: [UInt8]

    /// The number of frets available on the instrument. Defaults to 24.
    public let fretCount: Int

    /// The number of strings, derived from the tuning array.
    public var stringCount: Int { tuning.count }

    /// Creates a custom string instrument.
    ///
    /// - Parameters:
    ///   - id: A unique identifier for this instrument configuration.
    ///   - name: A human-readable name.
    ///   - tuning: An array of MIDI note numbers for each open string (index 0 = bottom line).
    ///   - fretCount: Number of available frets. Defaults to 24.
    public init(id: String, name: String, tuning: [UInt8], fretCount: Int = 24) {
        self.id = id
        self.name = name
        self.tuning = tuning
        self.fretCount = fretCount
    }

    /// Returns the fret number needed to produce the given MIDI note on the specified string,
    /// or `nil` if the note is not playable on that string.
    ///
    /// - Parameters:
    ///   - midiNote: The target MIDI note number.
    ///   - string: The zero-based string index.
    /// - Returns: The fret number, or `nil` if out of range.
    public func fret(for midiNote: UInt8, onString string: Int) -> Int? {
        guard string >= 0, string < tuning.count else { return nil }
        let fret = Int(midiNote) - Int(tuning[string])
        guard fret >= 0, fret <= fretCount else { return nil }
        return fret
    }

    /// Returns the note names for each open string, from bottom to top.
    public var stringNames: [String] {
        tuning.map { noteName(for: $0) }
    }
}

// MARK: - Presets

extension StringInstrument {
    /// Standard 6-string guitar in E standard tuning (E2-A2-D3-G3-B3-E4).
    public static let guitar = StringInstrument(
        id: "guitar",
        name: "Guitar",
        tuning: [40, 45, 50, 55, 59, 64]
    )

    /// 7-string guitar in standard tuning (B1-E2-A2-D3-G3-B3-E4).
    public static let guitar7String = StringInstrument(
        id: "guitar7String",
        name: "Guitar 7-String",
        tuning: [35, 40, 45, 50, 55, 59, 64]
    )

    /// Guitar in Drop D tuning (D2-A2-D3-G3-B3-E4).
    public static let guitarDropD = StringInstrument(
        id: "guitarDropD",
        name: "Guitar Drop D",
        tuning: [38, 45, 50, 55, 59, 64]
    )

    /// Standard 4-string bass (E1-A1-D2-G2).
    public static let bass = StringInstrument(
        id: "bass",
        name: "Bass",
        tuning: [28, 33, 38, 43]
    )

    /// 5-string bass (B0-E1-A1-D2-G2).
    public static let bass5String = StringInstrument(
        id: "bass5String",
        name: "Bass 5-String",
        tuning: [23, 28, 33, 38, 43]
    )

    /// Standard ukulele in re-entrant tuning (G4-C4-E4-A4).
    public static let ukulele = StringInstrument(
        id: "ukulele",
        name: "Ukulele",
        tuning: [67, 60, 64, 69],
        fretCount: 17
    )

    /// Standard 5-string banjo with high G string (G4-D3-G3-B3-D4).
    public static let banjo = StringInstrument(
        id: "banjo",
        name: "Banjo",
        tuning: [67, 50, 55, 59, 62],
        fretCount: 22
    )
}
