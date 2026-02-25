@testable import Tablature
import XCTest

@MainActor
final class LiveTablatureModelTests: XCTestCase {
    // MARK: - Init

    func testDefaultInit() {
        let model = LiveTablatureModel(instrument: .guitar)
        XCTAssertEqual(model.instrument.stringCount, 6)
        XCTAssertEqual(model.timeWindow, 5.0)
        XCTAssertTrue(model.notes.isEmpty)
    }

    func testCustomTimeWindow() {
        let model = LiveTablatureModel(instrument: .bass, timeWindow: 10.0)
        XCTAssertEqual(model.timeWindow, 10.0)
        XCTAssertEqual(model.instrument.stringCount, 4)
    }

    // MARK: - Adding Notes

    func testAddNoteByValues() {
        let model = LiveTablatureModel(instrument: .guitar)
        model.addNote(string: 0, fret: 5)
        XCTAssertEqual(model.notes.count, 1)
        XCTAssertEqual(model.notes.first?.string, 0)
        XCTAssertEqual(model.notes.first?.fret, 5)
    }

    func testAddNoteWithArticulation() {
        let model = LiveTablatureModel(instrument: .guitar)
        model.addNote(string: 1, fret: 7, articulation: .hammerOn)
        XCTAssertEqual(model.notes.first?.articulation, .hammerOn)
    }

    func testAddPrebuiltNote() {
        let model = LiveTablatureModel(instrument: .guitar)
        let note = LiveNote(string: 2, fret: 3, time: 0.5)
        model.addNote(note)
        XCTAssertEqual(model.notes.count, 1)
        XCTAssertEqual(model.notes.first?.id, note.id)
    }

    func testMultipleNotes() {
        let model = LiveTablatureModel(instrument: .guitar)
        model.addNote(string: 0, fret: 0)
        model.addNote(string: 1, fret: 2)
        model.addNote(string: 2, fret: 2)
        XCTAssertEqual(model.notes.count, 3)
    }

    // MARK: - Pruning

    func testPruneRemovesOldNotes() {
        let model = LiveTablatureModel(instrument: .guitar, timeWindow: 2.0)

        // Add a note far in the past via the public API
        let oldNote = LiveNote(string: 0, fret: 5, time: -10.0)
        model.addNote(oldNote)

        // Adding another note triggers pruning; the old note should be gone
        model.addNote(string: 1, fret: 3)
        XCTAssertEqual(model.notes.count, 1)
        XCTAssertEqual(model.notes.first?.string, 1, "Only the new note should remain")
    }

    func testPruneKeepsRecentNotes() {
        let model = LiveTablatureModel(instrument: .guitar, timeWindow: 60.0)
        model.addNote(string: 0, fret: 5)
        model.addNote(string: 1, fret: 7)
        XCTAssertEqual(model.notes.count, 2, "Both recent notes should be kept")
    }

    // MARK: - Reset

    func testReset() {
        let model = LiveTablatureModel(instrument: .guitar)
        model.addNote(string: 0, fret: 5)
        model.addNote(string: 1, fret: 7)
        XCTAssertEqual(model.notes.count, 2)

        let oldStartDate = model.startDate
        model.reset()
        XCTAssertTrue(model.notes.isEmpty)
        XCTAssertGreaterThanOrEqual(model.startDate, oldStartDate)
    }

    // MARK: - Current Time

    func testCurrentTimeAdvances() {
        let model = LiveTablatureModel(instrument: .guitar)
        let t1 = model.currentTime
        // Current time should be non-negative
        XCTAssertGreaterThanOrEqual(t1, 0)
    }

    // MARK: - Time Window

    func testTimeWindowIsPublished() {
        let model = LiveTablatureModel(instrument: .guitar)
        model.timeWindow = 10.0
        XCTAssertEqual(model.timeWindow, 10.0)
    }
}
