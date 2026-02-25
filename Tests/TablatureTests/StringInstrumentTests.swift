@testable import Tablature
import XCTest

final class StringInstrumentTests: XCTestCase {
    // MARK: - Presets

    func testGuitarPreset() {
        let guitar = StringInstrument.guitar
        XCTAssertEqual(guitar.stringCount, 6)
        XCTAssertEqual(guitar.tuning, [40, 45, 50, 55, 59, 64])
        XCTAssertEqual(guitar.fretCount, 24)
        XCTAssertEqual(guitar.id, "guitar")
    }

    func testGuitar7StringPreset() {
        let guitar7 = StringInstrument.guitar7String
        XCTAssertEqual(guitar7.stringCount, 7)
        XCTAssertEqual(guitar7.tuning.first, 35) // B1
    }

    func testGuitarDropDPreset() {
        let dropD = StringInstrument.guitarDropD
        XCTAssertEqual(dropD.stringCount, 6)
        XCTAssertEqual(dropD.tuning[0], 38) // D2
    }

    func testBassPreset() {
        let bass = StringInstrument.bass
        XCTAssertEqual(bass.stringCount, 4)
        XCTAssertEqual(bass.tuning, [28, 33, 38, 43])
    }

    func testBass5StringPreset() {
        let bass5 = StringInstrument.bass5String
        XCTAssertEqual(bass5.stringCount, 5)
        XCTAssertEqual(bass5.tuning.first, 23) // B0
    }

    func testUkulelePreset() {
        let uke = StringInstrument.ukulele
        XCTAssertEqual(uke.stringCount, 4)
        XCTAssertEqual(uke.fretCount, 17)
        // Re-entrant tuning: G4-C4-E4-A4
        XCTAssertEqual(uke.tuning, [67, 60, 64, 69])
    }

    func testBanjoPreset() {
        let banjo = StringInstrument.banjo
        XCTAssertEqual(banjo.stringCount, 5)
        XCTAssertEqual(banjo.fretCount, 22)
    }

    // MARK: - String Names

    func testGuitarStringNames() {
        let names = StringInstrument.guitar.stringNames
        XCTAssertEqual(names, ["E2", "A2", "D3", "G3", "B3", "E4"])
    }

    func testUkuleleStringNames() {
        let names = StringInstrument.ukulele.stringNames
        XCTAssertEqual(names, ["G4", "C4", "E4", "A4"])
    }

    // MARK: - Fret Calculation

    func testOpenStringFret() {
        let guitar = StringInstrument.guitar
        // Open low E string (MIDI 40) on string 0 should be fret 0
        XCTAssertEqual(guitar.fret(for: 40, onString: 0), 0)
    }

    func testFrettedNote() {
        let guitar = StringInstrument.guitar
        // MIDI 45 on string 0 (open = 40) should be fret 5
        XCTAssertEqual(guitar.fret(for: 45, onString: 0), 5)
    }

    func testHighFret() {
        let guitar = StringInstrument.guitar
        // Fret 24 on string 0: MIDI 40 + 24 = 64
        XCTAssertEqual(guitar.fret(for: 64, onString: 0), 24)
    }

    func testFretBeyondRange() {
        let guitar = StringInstrument.guitar
        // Fret 25 on string 0: MIDI 40 + 25 = 65, beyond fretCount 24
        XCTAssertNil(guitar.fret(for: 65, onString: 0))
    }

    func testNoteBelowOpenString() {
        let guitar = StringInstrument.guitar
        // MIDI 39 is below open E2 (40) on string 0
        XCTAssertNil(guitar.fret(for: 39, onString: 0))
    }

    func testInvalidStringIndex() {
        let guitar = StringInstrument.guitar
        XCTAssertNil(guitar.fret(for: 60, onString: -1))
        XCTAssertNil(guitar.fret(for: 60, onString: 6))
    }

    // MARK: - Custom Instrument

    func testCustomInstrument() {
        let custom = StringInstrument(id: "custom", name: "Custom 3-String", tuning: [40, 50, 60], fretCount: 12)
        XCTAssertEqual(custom.stringCount, 3)
        XCTAssertEqual(custom.fretCount, 12)
        XCTAssertEqual(custom.fret(for: 52, onString: 1), 2)
        XCTAssertEqual(custom.fret(for: 63, onString: 2), 3)
    }

    func testCustomInstrumentFretLimit() {
        let custom = StringInstrument(id: "test", name: "Test", tuning: [60], fretCount: 5)
        XCTAssertEqual(custom.fret(for: 65, onString: 0), 5) // exactly at limit
        XCTAssertNil(custom.fret(for: 66, onString: 0)) // beyond limit
    }

    // MARK: - Codable

    func testCodable() throws {
        let original = StringInstrument.guitar
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(StringInstrument.self, from: data)
        XCTAssertEqual(original, decoded)
    }

    // MARK: - Identifiable / Hashable

    func testIdentifiable() {
        let guitar = StringInstrument.guitar
        XCTAssertEqual(guitar.id, "guitar")
    }

    func testHashable() {
        var set = Set<StringInstrument>()
        set.insert(.guitar)
        set.insert(.guitar)
        set.insert(.bass)
        XCTAssertEqual(set.count, 2)
    }
}
