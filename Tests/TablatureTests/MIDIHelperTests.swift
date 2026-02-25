@testable import Tablature
import XCTest

final class MIDIHelperTests: XCTestCase {
    func testMiddleC() {
        XCTAssertEqual(noteName(for: 60), "C4")
    }

    func testLowestNote() {
        XCTAssertEqual(noteName(for: 0), "C-1")
    }

    func testHighestNote() {
        XCTAssertEqual(noteName(for: 127), "G9")
    }

    func testSharps() {
        XCTAssertEqual(noteName(for: 61), "C#4")
        XCTAssertEqual(noteName(for: 70), "A#4")
    }

    func testGuitarOpenStrings() {
        XCTAssertEqual(noteName(for: 40), "E2")
        XCTAssertEqual(noteName(for: 45), "A2")
        XCTAssertEqual(noteName(for: 50), "D3")
        XCTAssertEqual(noteName(for: 55), "G3")
        XCTAssertEqual(noteName(for: 59), "B3")
        XCTAssertEqual(noteName(for: 64), "E4")
    }

    func testA440() {
        XCTAssertEqual(noteName(for: 69), "A4")
    }
}
