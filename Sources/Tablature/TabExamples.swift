import Foundation

extension TabSequence {
    /// "Smoke on the Water" — 2 measures of the iconic riff using power chords
    /// on strings 3 (G) and 4 (D). Demonstrates time-proportional layout and simultaneous notes.
    public static let smokeOnTheWater: TabSequence = {
        // The riff: G5-Bb5-C5 | G5-Bb5-Db5-C5
        // Played as dyads on strings 3 (G, index 3) and 4 (D, index 2)
        // Guitar standard tuning: string 2 = D3 (50), string 3 = G3 (55)
        let duration: TimeInterval = 4.0

        let measure1 = TabMeasure(duration: duration, notes: [
            // G5 power chord: D string fret 5, G string fret 0
            TabNote(string: 2, fret: 5, time: 0.0),
            TabNote(string: 3, fret: 0, time: 0.0),
            // Bb5: D string fret 8, G string fret 3
            TabNote(string: 2, fret: 8, time: 1.0),
            TabNote(string: 3, fret: 3, time: 1.0),
            // C6: D string fret 10, G string fret 5
            TabNote(string: 2, fret: 10, time: 2.0),
            TabNote(string: 3, fret: 5, time: 2.0),
        ])

        let measure2 = TabMeasure(duration: duration, notes: [
            // G5
            TabNote(string: 2, fret: 5, time: 0.0),
            TabNote(string: 3, fret: 0, time: 0.0),
            // Bb5
            TabNote(string: 2, fret: 8, time: 1.0),
            TabNote(string: 3, fret: 3, time: 1.0),
            // Db6: D string fret 11, G string fret 6
            TabNote(string: 2, fret: 11, time: 2.0),
            TabNote(string: 3, fret: 6, time: 2.0),
            // C6
            TabNote(string: 2, fret: 10, time: 3.0),
            TabNote(string: 3, fret: 5, time: 3.0),
        ])

        return TabSequence(instrument: .guitar, measures: [measure1, measure2])
    }()

    /// C major scale ascending — 2 measures, 8 notes across multiple strings.
    /// Demonstrates single notes spread across time positions.
    public static let cMajorScale: TabSequence = {
        let duration: TimeInterval = 4.0

        // C major scale in open position: C-D-E-F-G-A-B-C
        let measure1 = TabMeasure(duration: duration, notes: [
            TabNote(string: 1, fret: 3, time: 0.0),   // C3 on A string
            TabNote(string: 2, fret: 0, time: 0.5),   // D3 on D string
            TabNote(string: 2, fret: 2, time: 1.0),   // E3 on D string
            TabNote(string: 2, fret: 3, time: 1.5),   // F3 on D string
            TabNote(string: 3, fret: 0, time: 2.0),   // G3 on G string
            TabNote(string: 3, fret: 2, time: 2.5),   // A3 on G string
            TabNote(string: 4, fret: 0, time: 3.0),   // B3 on B string
            TabNote(string: 4, fret: 1, time: 3.5),   // C4 on B string
        ])

        // Descending: C-B-A-G-F-E-D-C
        let measure2 = TabMeasure(duration: duration, notes: [
            TabNote(string: 4, fret: 1, time: 0.0),   // C4
            TabNote(string: 4, fret: 0, time: 0.5),   // B3
            TabNote(string: 3, fret: 2, time: 1.0),   // A3
            TabNote(string: 3, fret: 0, time: 1.5),   // G3
            TabNote(string: 2, fret: 3, time: 2.0),   // F3
            TabNote(string: 2, fret: 2, time: 2.5),   // E3
            TabNote(string: 2, fret: 0, time: 3.0),   // D3
            TabNote(string: 1, fret: 3, time: 3.5),   // C3
        ])

        return TabSequence(instrument: .guitar, measures: [measure1, measure2])
    }()

    /// Blues lick demonstrating articulations: bend, hammer-on, pull-off, and slide.
    public static let bluesLick: TabSequence = {
        let duration: TimeInterval = 4.0

        let measure = TabMeasure(duration: duration, notes: [
            // Bend on B string: fret 8, whole-step bend
            TabNote(string: 4, fret: 8, time: 0.0, articulation: .bend(semitones: 2.0)),
            // Slide up on G string from fret 5 to 7
            TabNote(string: 3, fret: 5, time: 1.0),
            TabNote(string: 3, fret: 7, time: 1.5, articulation: .slideUp),
            // Hammer-on on B string from fret 5 to 7
            TabNote(string: 4, fret: 5, time: 2.0),
            TabNote(string: 4, fret: 7, time: 2.5, articulation: .hammerOn),
            // Pull-off on high E string from fret 8 to 5
            TabNote(string: 5, fret: 8, time: 3.0),
            TabNote(string: 5, fret: 5, time: 3.5, articulation: .pullOff),
        ])

        return TabSequence(instrument: .guitar, measures: [measure])
    }()

    /// E minor open chord — 1 measure, 6 simultaneous notes (all strings at time 0).
    /// Demonstrates vertical alignment of a full chord.
    public static let eMinorChord: TabSequence = {
        let measure = TabMeasure(duration: 4.0, notes: [
            TabNote(string: 0, fret: 0, time: 0.0),   // E2 open
            TabNote(string: 1, fret: 2, time: 0.0),   // B2 (A string fret 2)
            TabNote(string: 2, fret: 2, time: 0.0),   // E3 (D string fret 2)
            TabNote(string: 3, fret: 0, time: 0.0),   // G3 open
            TabNote(string: 4, fret: 0, time: 0.0),   // B3 open
            TabNote(string: 5, fret: 0, time: 0.0),   // E4 open
        ])

        return TabSequence(instrument: .guitar, measures: [measure])
    }()
}
