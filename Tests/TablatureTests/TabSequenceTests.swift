@testable import Tablature
import XCTest

final class TabSequenceTests: XCTestCase {
    // MARK: - Init

    func testDefaultInit() {
        let seq = TabSequence(instrument: .guitar)
        XCTAssertEqual(seq.instrument, .guitar)
        XCTAssertTrue(seq.measures.isEmpty)
    }

    func testInitWithMeasures() {
        let measures = [
            TabMeasure(duration: 2.0, notes: [TabNote(string: 0, fret: 5, time: 0.0)]),
            TabMeasure(duration: 2.0, notes: [TabNote(string: 1, fret: 3, time: 0.0)])
        ]
        let seq = TabSequence(instrument: .guitar, measures: measures)
        XCTAssertEqual(seq.measures.count, 2)
    }

    // MARK: - Total Duration

    func testTotalDuration() {
        let measures = [
            TabMeasure(duration: 2.0),
            TabMeasure(duration: 3.0),
            TabMeasure(duration: 1.5)
        ]
        let seq = TabSequence(instrument: .guitar, measures: measures)
        XCTAssertEqual(seq.totalDuration, 6.5, accuracy: 0.001)
    }

    func testTotalDurationEmpty() {
        let seq = TabSequence(instrument: .guitar)
        XCTAssertEqual(seq.totalDuration, 0.0)
    }

    // MARK: - Note Count

    func testNoteCount() {
        let measures = [
            TabMeasure(duration: 2.0, notes: [
                TabNote(string: 0, fret: 5, time: 0.0),
                TabNote(string: 1, fret: 3, time: 0.5)
            ]),
            TabMeasure(duration: 2.0, notes: [
                TabNote(string: 2, fret: 7, time: 0.0)
            ])
        ]
        let seq = TabSequence(instrument: .guitar, measures: measures)
        XCTAssertEqual(seq.noteCount, 3)
    }

    func testNoteCountEmpty() {
        let seq = TabSequence(instrument: .guitar)
        XCTAssertEqual(seq.noteCount, 0)
    }

    // MARK: - Mutability

    func testAppendMeasure() {
        var seq = TabSequence(instrument: .bass)
        seq.measures.append(TabMeasure(duration: 2.0))
        XCTAssertEqual(seq.measures.count, 1)
    }

    // MARK: - Instrument

    func testDifferentInstruments() {
        let guitarSeq = TabSequence(instrument: .guitar)
        let bassSeq = TabSequence(instrument: .bass)
        XCTAssertNotEqual(guitarSeq.instrument, bassSeq.instrument)
    }

    // MARK: - Identity

    func testUniqueIDs() {
        let a = TabSequence(instrument: .guitar)
        let b = TabSequence(instrument: .guitar)
        XCTAssertNotEqual(a.id, b.id)
    }

    // MARK: - Codable

    func testCodable() throws {
        let measures = [
            TabMeasure(duration: 2.0, notes: [
                TabNote(string: 0, fret: 5, time: 0.0, articulation: .slideUp)
            ])
        ]
        let original = TabSequence(instrument: .guitar, measures: measures)
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(TabSequence.self, from: data)
        XCTAssertEqual(original, decoded)
    }
}
