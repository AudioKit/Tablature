@testable import Tablature
import XCTest

final class TabMeasureTests: XCTestCase {
    // MARK: - Init

    func testDefaultInit() {
        let measure = TabMeasure(duration: 2.0)
        XCTAssertEqual(measure.duration, 2.0)
        XCTAssertEqual(measure.beatsPerBar, 4)
        XCTAssertEqual(measure.beatUnit, 4)
        XCTAssertTrue(measure.notes.isEmpty)
    }

    func testCustomTimeSignature() {
        let measure = TabMeasure(duration: 1.5, beatsPerBar: 3, beatUnit: 4)
        XCTAssertEqual(measure.beatsPerBar, 3)
        XCTAssertEqual(measure.beatUnit, 4)
    }

    func testInitWithNotes() {
        let notes = [
            TabNote(string: 0, fret: 5, time: 0.0),
            TabNote(string: 1, fret: 3, time: 0.5)
        ]
        let measure = TabMeasure(duration: 2.0, notes: notes)
        XCTAssertEqual(measure.notes.count, 2)
    }

    // MARK: - Sorted Notes

    func testSortedNotes() {
        let notes = [
            TabNote(string: 0, fret: 5, time: 1.5),
            TabNote(string: 1, fret: 3, time: 0.0),
            TabNote(string: 2, fret: 7, time: 0.5)
        ]
        let measure = TabMeasure(duration: 2.0, notes: notes)
        let sorted = measure.sortedNotes
        XCTAssertEqual(sorted[0].time, 0.0)
        XCTAssertEqual(sorted[1].time, 0.5)
        XCTAssertEqual(sorted[2].time, 1.5)
    }

    func testSortedNotesEmpty() {
        let measure = TabMeasure(duration: 2.0)
        XCTAssertTrue(measure.sortedNotes.isEmpty)
    }

    // MARK: - Mutability

    func testAddNote() {
        var measure = TabMeasure(duration: 2.0)
        measure.notes.append(TabNote(string: 0, fret: 5, time: 0.0))
        XCTAssertEqual(measure.notes.count, 1)
    }

    // MARK: - Identity

    func testUniqueIDs() {
        let a = TabMeasure(duration: 2.0)
        let b = TabMeasure(duration: 2.0)
        XCTAssertNotEqual(a.id, b.id)
    }

    // MARK: - Codable

    func testCodable() throws {
        let notes = [TabNote(string: 0, fret: 5, time: 0.0, articulation: .hammerOn)]
        let original = TabMeasure(duration: 2.0, beatsPerBar: 3, beatUnit: 8, notes: notes)
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(TabMeasure.self, from: data)
        XCTAssertEqual(original, decoded)
    }
}
