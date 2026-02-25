import Foundation

/// A single note event in tablature: which string, which fret, and when.
public struct TabNote: Identifiable, Equatable, Hashable, Codable, Sendable {
    /// Unique identifier for this note event.
    public let id: UUID

    /// Zero-based string index (0 = bottom tablature line, physically closest to player).
    public let string: Int

    /// Fret number (0 = open string).
    public let fret: Int

    /// Time position in seconds from the start of the containing measure.
    public let time: TimeInterval

    /// Optional articulation applied to this note.
    public let articulation: Articulation?

    /// Creates a tab note with explicit string, fret, and time values.
    ///
    /// - Parameters:
    ///   - string: Zero-based string index.
    ///   - fret: Fret number (0 for open string).
    ///   - time: Time position in seconds within the measure.
    ///   - articulation: Optional playing technique annotation.
    ///   - id: Unique identifier. Defaults to a new UUID.
    public init(string: Int, fret: Int, time: TimeInterval, articulation: Articulation? = nil, id: UUID = UUID()) {
        self.string = string
        self.fret = fret
        self.time = time
        self.articulation = articulation
        self.id = id
    }

    /// Creates a tab note from a MIDI note number on a specific string of an instrument.
    ///
    /// Returns `nil` if the MIDI note is not playable on the given string (fret out of range).
    ///
    /// - Parameters:
    ///   - string: Zero-based string index.
    ///   - midiNote: MIDI note number (0–127).
    ///   - time: Time position in seconds within the measure.
    ///   - instrument: The instrument whose tuning is used to derive the fret.
    ///   - articulation: Optional playing technique annotation.
    ///   - id: Unique identifier. Defaults to a new UUID.
    public init?(string: Int, midiNote: UInt8, time: TimeInterval, instrument: StringInstrument,
                 articulation: Articulation? = nil, id: UUID = UUID()) {
        guard let fret = instrument.fret(for: midiNote, onString: string) else { return nil }
        self.string = string
        self.fret = fret
        self.time = time
        self.articulation = articulation
        self.id = id
    }
}
