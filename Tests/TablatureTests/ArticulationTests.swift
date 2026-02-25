@testable import Tablature
import XCTest

final class ArticulationTests: XCTestCase {
    func testEquality() {
        XCTAssertEqual(Articulation.hammerOn, Articulation.hammerOn)
        XCTAssertEqual(Articulation.pullOff, Articulation.pullOff)
        XCTAssertEqual(Articulation.slideUp, Articulation.slideUp)
        XCTAssertEqual(Articulation.slideDown, Articulation.slideDown)
        XCTAssertEqual(Articulation.pitchBendArrow, Articulation.pitchBendArrow)
    }

    func testBendEquality() {
        XCTAssertEqual(Articulation.bend(semitones: 1.0), Articulation.bend(semitones: 1.0))
        XCTAssertNotEqual(Articulation.bend(semitones: 1.0), Articulation.bend(semitones: 2.0))
    }

    func testInequality() {
        XCTAssertNotEqual(Articulation.hammerOn, Articulation.pullOff)
        XCTAssertNotEqual(Articulation.slideUp, Articulation.slideDown)
        XCTAssertNotEqual(Articulation.bend(semitones: 1.0), Articulation.hammerOn)
    }

    func testHashable() {
        var set = Set<Articulation>()
        set.insert(.hammerOn)
        set.insert(.hammerOn)
        set.insert(.pullOff)
        XCTAssertEqual(set.count, 2)
    }

    func testCodable() throws {
        let original = Articulation.bend(semitones: 1.5)
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(Articulation.self, from: data)
        XCTAssertEqual(original, decoded)
    }

    func testAllCasesCodable() throws {
        let cases: [Articulation] = [
            .bend(semitones: 2.0),
            .hammerOn,
            .pullOff,
            .slideUp,
            .slideDown,
            .pitchBendArrow
        ]
        for original in cases {
            let data = try JSONEncoder().encode(original)
            let decoded = try JSONDecoder().decode(Articulation.self, from: data)
            XCTAssertEqual(original, decoded)
        }
    }
}
