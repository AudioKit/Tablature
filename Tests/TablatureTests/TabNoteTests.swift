@testable import Tablature
import XCTest

final class TabNoteTests: XCTestCase {
    // MARK: - Direct Init

    func testDirectInit() {
        let note = TabNote(string: 0, fret: 5, time: 1.0)
        XCTAssertEqual(note.string, 0)
        XCTAssertEqual(note.fret, 5)
        XCTAssertEqual(note.time, 1.0)
        XCTAssertNil(note.articulation)
    }

    func testDirectInitWithArticulation() {
        let note = TabNote(string: 2, fret: 7, time: 0.5, articulation: .hammerOn)
        XCTAssertEqual(note.articulation, .hammerOn)
    }

    func testOpenString() {
        let note = TabNote(string: 0, fret: 0, time: 0.0)
        XCTAssertEqual(note.fret, 0)
    }

    // MARK: - MIDI Init

    func testMIDIInit() {
        let guitar = StringInstrument.guitar
        // A2 (MIDI 45) on string 0 (open E2 = 40) -> fret 5
        let note = TabNote(string: 0, midiNote: 45, time: 0.0, instrument: guitar)
        XCTAssertNotNil(note)
        XCTAssertEqual(note?.fret, 5)
        XCTAssertEqual(note?.string, 0)
    }

    func testMIDIInitOpenString() {
        let guitar = StringInstrument.guitar
        // E2 (MIDI 40) on string 0 (open E2 = 40) -> fret 0
        let note = TabNote(string: 0, midiNote: 40, time: 0.0, instrument: guitar)
        XCTAssertNotNil(note)
        XCTAssertEqual(note?.fret, 0)
    }

    func testMIDIInitUnplayable() {
        let guitar = StringInstrument.guitar
        // MIDI 39 is below open E2 (40) on string 0
        let note = TabNote(string: 0, midiNote: 39, time: 0.0, instrument: guitar)
        XCTAssertNil(note)
    }

    func testMIDIInitBeyondFretCount() {
        let guitar = StringInstrument.guitar
        // MIDI 65 on string 0 would be fret 25, beyond 24
        let note = TabNote(string: 0, midiNote: 65, time: 0.0, instrument: guitar)
        XCTAssertNil(note)
    }

    func testMIDIInitWithArticulation() {
        let guitar = StringInstrument.guitar
        let note = TabNote(string: 0, midiNote: 45, time: 0.0, instrument: guitar, articulation: .bend(semitones: 1.0))
        XCTAssertNotNil(note)
        XCTAssertEqual(note?.articulation, .bend(semitones: 1.0))
    }

    func testMIDIInitInvalidString() {
        let guitar = StringInstrument.guitar
        let note = TabNote(string: 10, midiNote: 60, time: 0.0, instrument: guitar)
        XCTAssertNil(note)
    }

    // MARK: - Identity

    func testUniqueIDs() {
        let a = TabNote(string: 0, fret: 5, time: 0.0)
        let b = TabNote(string: 0, fret: 5, time: 0.0)
        XCTAssertNotEqual(a.id, b.id)
    }

    func testCustomID() {
        let customID = UUID()
        let note = TabNote(string: 0, fret: 5, time: 0.0, id: customID)
        XCTAssertEqual(note.id, customID)
    }

    // MARK: - Equatable

    func testEquality() {
        let id = UUID()
        let a = TabNote(string: 0, fret: 5, time: 1.0, id: id)
        let b = TabNote(string: 0, fret: 5, time: 1.0, id: id)
        XCTAssertEqual(a, b)
    }

    // MARK: - Codable

    func testCodable() throws {
        let original = TabNote(string: 2, fret: 7, time: 1.5, articulation: .slideUp)
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(TabNote.self, from: data)
        XCTAssertEqual(original, decoded)
    }
}
