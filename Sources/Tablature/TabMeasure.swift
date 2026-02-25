import Foundation

/// A single measure of tablature containing notes and timing information.
public struct TabMeasure: Identifiable, Equatable, Hashable, Codable, Sendable {
    /// Unique identifier for this measure.
    public let id: UUID

    /// Duration of the measure in seconds.
    public let duration: TimeInterval

    /// Time signature beats per bar (e.g. 4 for 4/4 time). Defaults to 4.
    public let beatsPerBar: Int

    /// Time signature beat unit (e.g. 4 for quarter note). Defaults to 4.
    public let beatUnit: Int

    /// The notes in this measure, in no particular order.
    public var notes: [TabNote]

    /// Creates a tablature measure.
    ///
    /// - Parameters:
    ///   - duration: Duration of the measure in seconds.
    ///   - beatsPerBar: Beats per bar in the time signature. Defaults to 4.
    ///   - beatUnit: Beat unit in the time signature. Defaults to 4.                       u
    ///   - notes: The notes contained in this measure.
    ///   - id: Unique identifier. Defaults to a new UUID.
    public init(duration: TimeInterval, beatsPerBar: Int = 4, beatUnit: Int = 4,
                notes: [TabNote] = [], id: UUID = UUID()) {
        self.duration = duration
        self.beatsPerBar = beatsPerBar
        self.beatUnit = beatUnit
        self.notes = notes
        self.id = id
    }

    /// Returns notes sorted by their time position.
    public var sortedNotes: [TabNote] {
        notes.sorted { $0.time < $1.time }
    }
}
