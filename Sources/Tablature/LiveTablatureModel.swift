import Foundation
import Combine

/// An observable model that accumulates timestamped notes for real-time
/// tablature rendering. Notes are positioned by absolute time elapsed since
/// the model was created (or last reset).
///
/// ```swift
/// let model = LiveTablatureModel(instrument: .guitar)
/// model.addNote(string: 0, fret: 5)
/// ```
@MainActor
public class LiveTablatureModel: ObservableObject {

    /// The instrument whose tuning and string count drive the tablature layout.
    public let instrument: StringInstrument

    /// The date when the model was created or last reset. Used as the time origin
    /// for all note timestamps.
    public private(set) var startDate: Date

    /// The number of seconds visible on screen. Notes older than this are pruned.
    @Published public var timeWindow: TimeInterval

    /// All notes currently held in the model. Off-screen notes are pruned
    /// automatically when new notes are added.
    @Published public private(set) var notes: [LiveNote] = []

    /// Creates a new live tablature model.
    ///
    /// - Parameters:
    ///   - instrument: The string instrument to use.
    ///   - timeWindow: Visible time window in seconds. Defaults to 5.
    public init(instrument: StringInstrument, timeWindow: TimeInterval = 5.0) {
        self.instrument = instrument
        self.timeWindow = timeWindow
        self.startDate = Date()
    }

    /// The elapsed time in seconds since the session started.
    public var currentTime: TimeInterval {
        Date().timeIntervalSince(startDate)
    }

    /// Adds a note at the current time.
    ///
    /// - Parameters:
    ///   - string: Zero-based string index.
    ///   - fret: Fret number (0 for open string).
    ///   - articulation: Optional playing technique annotation.
    public func addNote(string: Int, fret: Int, articulation: Articulation? = nil) {
        let note = LiveNote(
            string: string,
            fret: fret,
            time: currentTime,
            articulation: articulation
        )
        notes.append(note)
        pruneOffScreenNotes()
    }

    /// Adds a pre-built `LiveNote` directly.
    ///
    /// - Parameter note: The note to add.
    public func addNote(_ note: LiveNote) {
        notes.append(note)
        pruneOffScreenNotes()
    }

    /// Clears all notes and resets the start time to now.
    public func reset() {
        notes.removeAll()
        startDate = Date()
    }

    /// Removes notes that have scrolled off the left edge of the visible time window.
    func pruneOffScreenNotes() {
        let cutoff = currentTime - timeWindow
        notes.removeAll { $0.time < cutoff }
    }
}
