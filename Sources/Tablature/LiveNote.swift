import Foundation

/// A single note event in a live tablature stream, positioned by absolute time
/// rather than relative to a measure.
public struct LiveNote: Identifiable, Sendable {
    /// Unique identifier for this note event.
    public let id: UUID

    /// Zero-based string index (0 = bottom tablature line).
    public let string: Int

    /// Fret number (0 = open string).
    public let fret: Int

    /// Time in seconds since the live session started.
    public let time: TimeInterval

    /// Optional articulation applied to this note.
    public let articulation: Articulation?

    /// Creates a live note with explicit values.
    ///
    /// - Parameters:
    ///   - string: Zero-based string index.
    ///   - fret: Fret number (0 for open string).
    ///   - time: Time in seconds since session start.
    ///   - articulation: Optional playing technique annotation.
    ///   - id: Unique identifier. Defaults to a new UUID.
    public init(string: Int, fret: Int, time: TimeInterval,
                articulation: Articulation? = nil, id: UUID = UUID()) {
        self.string = string
        self.fret = fret
        self.time = time
        self.articulation = articulation
        self.id = id
    }
}
