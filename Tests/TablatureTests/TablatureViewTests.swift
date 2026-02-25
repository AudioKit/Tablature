import XCTest
@testable import Tablature

final class TablatureViewTests: XCTestCase {

    // MARK: - Example Data Validation

    func testSmokeOnTheWaterHasCorrectStructure() {
        let seq = TabSequence.smokeOnTheWater
        XCTAssertEqual(seq.instrument, .guitar)
        XCTAssertEqual(seq.measures.count, 2)
        XCTAssertEqual(seq.measures[0].notes.count, 6)
        XCTAssertEqual(seq.measures[1].notes.count, 8)
    }

    func testSmokeOnTheWaterNotesInRange() {
        let seq = TabSequence.smokeOnTheWater
        for measure in seq.measures {
            for note in measure.notes {
                XCTAssertGreaterThanOrEqual(note.string, 0)
                XCTAssertLessThan(note.string, seq.instrument.stringCount)
                XCTAssertGreaterThanOrEqual(note.fret, 0)
                XCTAssertLessThanOrEqual(note.fret, seq.instrument.fretCount)
                XCTAssertGreaterThanOrEqual(note.time, 0)
                XCTAssertLessThan(note.time, measure.duration)
            }
        }
    }

    func testCMajorScaleHasCorrectStructure() {
        let seq = TabSequence.cMajorScale
        XCTAssertEqual(seq.instrument, .guitar)
        XCTAssertEqual(seq.measures.count, 2)
        XCTAssertEqual(seq.measures[0].notes.count, 8)
        XCTAssertEqual(seq.measures[1].notes.count, 8)
    }

    func testCMajorScaleNotesInRange() {
        let seq = TabSequence.cMajorScale
        for measure in seq.measures {
            for note in measure.notes {
                XCTAssertGreaterThanOrEqual(note.string, 0)
                XCTAssertLessThan(note.string, seq.instrument.stringCount)
                XCTAssertGreaterThanOrEqual(note.fret, 0)
                XCTAssertLessThanOrEqual(note.fret, seq.instrument.fretCount)
                XCTAssertGreaterThanOrEqual(note.time, 0)
                XCTAssertLessThan(note.time, measure.duration)
            }
        }
    }

    func testEMinorChordHasCorrectStructure() {
        let seq = TabSequence.eMinorChord
        XCTAssertEqual(seq.instrument, .guitar)
        XCTAssertEqual(seq.measures.count, 1)
        XCTAssertEqual(seq.measures[0].notes.count, 6)
    }

    func testEMinorChordAllStringsUsed() {
        let seq = TabSequence.eMinorChord
        let strings = Set(seq.measures[0].notes.map { $0.string })
        XCTAssertEqual(strings, Set(0..<6), "E minor chord should use all 6 strings")
    }

    func testEMinorChordAllNotesAtTimeZero() {
        let seq = TabSequence.eMinorChord
        for note in seq.measures[0].notes {
            XCTAssertEqual(note.time, 0.0, "All chord notes should be at time 0")
        }
    }

    func testEMinorChordNotesInRange() {
        let seq = TabSequence.eMinorChord
        for note in seq.measures[0].notes {
            XCTAssertGreaterThanOrEqual(note.string, 0)
            XCTAssertLessThan(note.string, seq.instrument.stringCount)
            XCTAssertGreaterThanOrEqual(note.fret, 0)
            XCTAssertLessThanOrEqual(note.fret, seq.instrument.fretCount)
        }
    }

    // MARK: - Coordinate Mapping (via TablatureStyle)

    func testXPositionAtMeasureStart() {
        let style = TablatureStyle.default
        let measure = TabMeasure(duration: 4.0, notes: [
            TabNote(string: 0, fret: 5, time: 0.0)
        ])
        let x = style.xPosition(for: measure.notes[0], in: measure)
        XCTAssertEqual(x, 15, accuracy: 0.01, "Note at time 0 should be at left inset")
    }

    func testXPositionAtMeasureEnd() {
        let style = TablatureStyle.default
        let measure = TabMeasure(duration: 4.0, notes: [
            TabNote(string: 0, fret: 5, time: 4.0)
        ])
        let x = style.xPosition(for: measure.notes[0], in: measure)
        XCTAssertEqual(x, 285, accuracy: 0.01, "Note at end should be at right inset")
    }

    func testXPositionAtMidpoint() {
        let style = TablatureStyle.default
        let measure = TabMeasure(duration: 4.0, notes: [
            TabNote(string: 0, fret: 5, time: 2.0)
        ])
        let x = style.xPosition(for: measure.notes[0], in: measure)
        XCTAssertEqual(x, 150, accuracy: 0.01, "Note at midpoint should be centered")
    }

    func testYPositionLowestString() {
        let style = TablatureStyle.default
        let note = TabNote(string: 0, fret: 0, time: 0.0)
        let y = style.yPosition(for: note, stringCount: 6)
        XCTAssertEqual(y, 110, accuracy: 0.01, "String 0 (low E) should be at bottom")
    }

    func testYPositionHighestString() {
        let style = TablatureStyle.default
        let note = TabNote(string: 5, fret: 0, time: 0.0)
        let y = style.yPosition(for: note, stringCount: 6)
        XCTAssertEqual(y, 10, accuracy: 0.01, "String 5 (high E) should be at top")
    }

    func testYPositionMiddleString() {
        let style = TablatureStyle.default
        let note = TabNote(string: 3, fret: 0, time: 0.0)
        let y = style.yPosition(for: note, stringCount: 6)
        XCTAssertEqual(y, 50, accuracy: 0.01, "String 3 (G) should be 2 lines from top")
    }
}
