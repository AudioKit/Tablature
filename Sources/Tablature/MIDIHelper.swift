import Foundation

/// Note names using sharps only (tablature doesn't show key signatures).
private let noteNames = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]

/// Converts a MIDI note number (0–127) to a human-readable note name such as "C4" or "E2".
///
/// Uses scientific pitch notation where MIDI note 60 = C4 (middle C).
/// Always uses sharps, never flats.
///
/// - Parameter midiNote: A MIDI note number in the range 0...127.
/// - Returns: A string like "C4", "G#2", or "A#0".
public func noteName(for midiNote: UInt8) -> String {
    let note = Int(midiNote) % 12
    let octave = Int(midiNote) / 12 - 1
    return "\(noteNames[note])\(octave)"
}
