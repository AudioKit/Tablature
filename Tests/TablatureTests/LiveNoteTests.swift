@testable import Tablature
import XCTest

final class LiveNoteTests: XCTestCase {
    // MARK: - Init

    func testDirectInit() {
        let note = LiveNote(string: 2, fret: 5, time: 1.5)
        XCTAssertEqual(note.string, 2)
        XCTAssertEqual(note.fret, 5)
        XCTAssertEqual(note.time, 1.5)
        XCTAssertNil(note.articulation)
    }

    func testInitWithArticulation() {
        let note = LiveNote(string: 0, fret: 3, time: 0.0, articulation: .pitchBendArrow)
        XCTAssertEqual(note.articulation, .pitchBendArrow)
    }

    func testOpenString() {
        let note = LiveNote(string: 0, fret: 0, time: 0.0)
        XCTAssertEqual(note.fret, 0)
    }

    // MARK: - Identity

    func testUniqueIDs() {
        let a = LiveNote(string: 0, fret: 5, time: 0.0)
        let b = LiveNote(string: 0, fret: 5, time: 0.0)
        XCTAssertNotEqual(a.id, b.id)
    }

    func testCustomID() {
        let customID = UUID()
        let note = LiveNote(string: 0, fret: 5, time: 0.0, id: customID)
        XCTAssertEqual(note.id, customID)
    }
}
