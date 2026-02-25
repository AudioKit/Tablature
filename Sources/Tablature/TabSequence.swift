import Foundation

/// An ordered collection of measures representing a full tablature passage.
public struct TabSequence: Identifiable, Equatable, Hashable, Codable, Sendable {
    /// Unique identifier for this sequence.
    public let id: UUID

    /// The instrument this tablature is written for.
    public let instrument: StringInstrument

    /// The ordered measures in this tablature passage.
    public var measures: [TabMeasure]

    /// Creates a tablature sequence.
    ///
    /// - Parameters:
    ///   - instrument: The string instrument this tablature targets.
    ///   - measures: An ordered array of measures. Defaults to empty.
    ///   - id: Unique identifier. Defaults to a new UUID.
    public init(instrument: StringInstrument, measures: [TabMeasure] = [], id: UUID = UUID()) {
        self.instrument = instrument
        self.measures = measures
        self.id = id
    }

    /// Total duration of the sequence in seconds.
    public var totalDuration: TimeInterval {
        measures.reduce(0) { $0 + $1.duration }
    }

    /// Total number of notes across all measures.
    public var noteCount: Int {
        measures.reduce(0) { $0 + $1.notes.count }
    }
}
