import Foundation

/// A playing technique or articulation applied to a tablature note.
public enum Articulation: Hashable, Equatable, Codable, Sendable {
    /// A string bend by the given number of semitones (e.g. 1.0 for a whole-step bend).
    case bend(semitones: Double)

    /// Hammer-on to a higher fret on the same string.
    case hammerOn

    /// Pull-off to a lower fret on the same string.
    case pullOff

    /// Slide up to the next note on the same string.
    case slideUp

    /// Slide down to the next note on the same string.
    case slideDown

    /// A pitch-bend arrow indicator, used for MIDI pitch bend events exceeding one semitone.
    case pitchBendArrow
}
