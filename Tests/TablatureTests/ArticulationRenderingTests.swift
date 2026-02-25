import XCTest
@testable import Tablature

final class ArticulationRenderingTests: XCTestCase {

    // MARK: - Articulation Pairs

    func testHammerOnPair() {
        let measure = TabMeasure(duration: 4.0, notes: [
            TabNote(string: 4, fret: 5, time: 0.0),
            TabNote(string: 4, fret: 7, time: 1.0, articulation: .hammerOn),
        ])
        let pairs = measure.articulationPairs
        XCTAssertEqual(pairs.count, 1)
        XCTAssertEqual(pairs[0].from.fret, 5)
        XCTAssertEqual(pairs[0].to.fret, 7)
        XCTAssertEqual(pairs[0].articulation, .hammerOn)
    }

    func testPullOffPair() {
        let measure = TabMeasure(duration: 4.0, notes: [
            TabNote(string: 5, fret: 8, time: 0.0),
            TabNote(string: 5, fret: 5, time: 1.0, articulation: .pullOff),
        ])
        let pairs = measure.articulationPairs
        XCTAssertEqual(pairs.count, 1)
        XCTAssertEqual(pairs[0].from.fret, 8)
        XCTAssertEqual(pairs[0].to.fret, 5)
        XCTAssertEqual(pairs[0].articulation, .pullOff)
    }

    func testSlideUpPair() {
        let measure = TabMeasure(duration: 4.0, notes: [
            TabNote(string: 3, fret: 5, time: 0.0),
            TabNote(string: 3, fret: 7, time: 1.0, articulation: .slideUp),
        ])
        let pairs = measure.articulationPairs
        XCTAssertEqual(pairs.count, 1)
        XCTAssertEqual(pairs[0].articulation, .slideUp)
    }

    func testSlideDownPair() {
        let measure = TabMeasure(duration: 4.0, notes: [
            TabNote(string: 3, fret: 7, time: 0.0),
            TabNote(string: 3, fret: 5, time: 1.0, articulation: .slideDown),
        ])
        let pairs = measure.articulationPairs
        XCTAssertEqual(pairs.count, 1)
        XCTAssertEqual(pairs[0].articulation, .slideDown)
    }

    func testBendIsNotAPair() {
        let measure = TabMeasure(duration: 4.0, notes: [
            TabNote(string: 4, fret: 8, time: 0.0, articulation: .bend(semitones: 2.0)),
        ])
        let pairs = measure.articulationPairs
        XCTAssertEqual(pairs.count, 0, "Bend is not a between-note articulation")
    }

    func testPitchBendArrowIsNotAPair() {
        let measure = TabMeasure(duration: 4.0, notes: [
            TabNote(string: 4, fret: 0, time: 0.0),
            TabNote(string: 4, fret: 0, time: 1.0, articulation: .pitchBendArrow),
        ])
        let pairs = measure.articulationPairs
        XCTAssertEqual(pairs.count, 0, "Pitch bend arrow is not a between-note articulation")
    }

    func testNoArticulationsReturnsNoPairs() {
        let measure = TabMeasure(duration: 4.0, notes: [
            TabNote(string: 0, fret: 5, time: 0.0),
            TabNote(string: 0, fret: 7, time: 1.0),
        ])
        let pairs = measure.articulationPairs
        XCTAssertEqual(pairs.count, 0)
    }

    func testEmptyMeasureReturnsNoPairs() {
        let measure = TabMeasure(duration: 4.0, notes: [])
        let pairs = measure.articulationPairs
        XCTAssertEqual(pairs.count, 0)
    }

    func testMultiplePairsOnDifferentStrings() {
        let measure = TabMeasure(duration: 4.0, notes: [
            TabNote(string: 3, fret: 5, time: 0.0),
            TabNote(string: 3, fret: 7, time: 1.0, articulation: .slideUp),
            TabNote(string: 4, fret: 5, time: 0.0),
            TabNote(string: 4, fret: 7, time: 1.0, articulation: .hammerOn),
        ])
        let pairs = measure.articulationPairs
        XCTAssertEqual(pairs.count, 2)
    }

    func testPairsUseTimeOrder() {
        // Notes added out of order — pairs should still match by time
        let measure = TabMeasure(duration: 4.0, notes: [
            TabNote(string: 3, fret: 7, time: 1.0, articulation: .hammerOn),
            TabNote(string: 3, fret: 5, time: 0.0),
        ])
        let pairs = measure.articulationPairs
        XCTAssertEqual(pairs.count, 1)
        XCTAssertEqual(pairs[0].from.fret, 5, "Earlier note should be 'from'")
        XCTAssertEqual(pairs[0].to.fret, 7, "Later note should be 'to'")
    }

    func testNotesOnDifferentStringsDontPair() {
        let measure = TabMeasure(duration: 4.0, notes: [
            TabNote(string: 3, fret: 5, time: 0.0),
            TabNote(string: 4, fret: 7, time: 1.0, articulation: .hammerOn),
        ])
        // String 4 has only one note, so no pair for the hammer-on
        let pairs = measure.articulationPairs
        XCTAssertEqual(pairs.count, 0, "Notes on different strings should not form a pair")
    }

    // MARK: - Bend Labels

    func testBendLabelQuarterStep() {
        XCTAssertEqual(bendLabel(semitones: 0.5), "1/4")
    }

    func testBendLabelHalfStep() {
        XCTAssertEqual(bendLabel(semitones: 1.0), "1/2")
    }

    func testBendLabelFullStep() {
        XCTAssertEqual(bendLabel(semitones: 2.0), "full")
    }

    func testBendLabelStepAndHalf() {
        XCTAssertEqual(bendLabel(semitones: 3.0), "1 1/2")
    }

    func testBendLabelCustomValue() {
        // Non-standard value should format numerically
        let label = bendLabel(semitones: 4.0)
        XCTAssertEqual(label, "4")
    }

    // MARK: - Blues Lick Example Validation

    func testBluesLickHasCorrectStructure() {
        let seq = TabSequence.bluesLick
        XCTAssertEqual(seq.instrument, .guitar)
        XCTAssertEqual(seq.measures.count, 1)
        XCTAssertEqual(seq.measures[0].notes.count, 7)
    }

    func testBluesLickArticulations() {
        let notes = TabSequence.bluesLick.measures[0].notes
        // Verify articulation types present
        let articulations = notes.compactMap { $0.articulation }
        XCTAssertEqual(articulations.count, 4)
        XCTAssertTrue(articulations.contains(where: {
            if case .bend = $0 { return true }; return false
        }))
        XCTAssertTrue(articulations.contains(.slideUp))
        XCTAssertTrue(articulations.contains(.hammerOn))
        XCTAssertTrue(articulations.contains(.pullOff))
    }

    func testBluesLickArticulationPairs() {
        let measure = TabSequence.bluesLick.measures[0]
        let pairs = measure.articulationPairs
        // Should have 3 between-note pairs: slide, hammer-on, pull-off (bend is not a pair)
        XCTAssertEqual(pairs.count, 3)
    }

    func testBluesLickNotesInRange() {
        let seq = TabSequence.bluesLick
        for note in seq.measures[0].notes {
            XCTAssertGreaterThanOrEqual(note.string, 0)
            XCTAssertLessThan(note.string, seq.instrument.stringCount)
            XCTAssertGreaterThanOrEqual(note.fret, 0)
            XCTAssertLessThanOrEqual(note.fret, seq.instrument.fretCount)
        }
    }
}
