import XCTest
@testable import Tablature

final class TablatureStyleTests: XCTestCase {

    // MARK: - Default Values

    func testDefaultLabelColumnWidth() {
        XCTAssertEqual(TablatureStyle.default.labelColumnWidth, 30)
    }

    func testDefaultStringSpacing() {
        XCTAssertEqual(TablatureStyle.default.stringSpacing, 20)
    }

    func testDefaultMeasureWidth() {
        XCTAssertEqual(TablatureStyle.default.measureWidth, 300)
    }

    func testDefaultMeasureInset() {
        XCTAssertEqual(TablatureStyle.default.measureInset, 15)
    }

    func testDefaultLineThickness() {
        XCTAssertEqual(TablatureStyle.default.lineThickness, 1)
    }

    func testDefaultVerticalPadding() {
        XCTAssertEqual(TablatureStyle.default.verticalPadding, 10)
    }

    func testDefaultFretBackgroundColorIsNil() {
        XCTAssertNil(TablatureStyle.default.fretBackgroundColor)
    }

    // MARK: - Resolved Colors

    func testResolvedFretBackgroundColorWithExplicitValue() {
        var style = TablatureStyle.default
        style.fretBackgroundColor = .red
        // When an explicit color is set, it should be returned
        XCTAssertNotNil(style.fretBackgroundColor)
    }

    func testResolvedFretBackgroundColorWithNilUsesPlatformDefault() {
        let style = TablatureStyle.default
        // When nil, resolvedFretBackgroundColor should still return a valid color
        // (platform-adaptive). We just verify it doesn't crash.
        _ = style.resolvedFretBackgroundColor
    }

    // MARK: - Coordinate Helpers

    func testStaffHeightForSixStrings() {
        let style = TablatureStyle.default
        XCTAssertEqual(style.staffHeight(stringCount: 6), 100)
    }

    func testStaffHeightForFourStrings() {
        let style = TablatureStyle.default
        XCTAssertEqual(style.staffHeight(stringCount: 4), 60)
    }

    func testStaffHeightForOneString() {
        let style = TablatureStyle.default
        XCTAssertEqual(style.staffHeight(stringCount: 1), 0)
    }

    func testTotalHeightIncludesPadding() {
        let style = TablatureStyle.default
        // staffHeight(6) = 100, padding = 10 * 2 = 20
        XCTAssertEqual(style.totalHeight(stringCount: 6), 120)
    }

    func testXPositionAtStart() {
        let style = TablatureStyle.default
        let measure = TabMeasure(duration: 4.0, notes: [
            TabNote(string: 0, fret: 0, time: 0.0)
        ])
        let x = style.xPosition(for: measure.notes[0], in: measure)
        XCTAssertEqual(x, 15, accuracy: 0.01)
    }

    func testXPositionAtEnd() {
        let style = TablatureStyle.default
        let measure = TabMeasure(duration: 4.0, notes: [
            TabNote(string: 0, fret: 0, time: 4.0)
        ])
        let x = style.xPosition(for: measure.notes[0], in: measure)
        XCTAssertEqual(x, 285, accuracy: 0.01)
    }

    func testXPositionWithZeroDuration() {
        let style = TablatureStyle.default
        let measure = TabMeasure(duration: 0.0, notes: [
            TabNote(string: 0, fret: 0, time: 0.0)
        ])
        let x = style.xPosition(for: measure.notes[0], in: measure)
        XCTAssertEqual(x, 15, accuracy: 0.01, "Zero-duration measure should place notes at inset")
    }

    func testYPositionTopString() {
        let style = TablatureStyle.default
        let note = TabNote(string: 5, fret: 0, time: 0.0)
        XCTAssertEqual(style.yPosition(for: note, stringCount: 6), 10, accuracy: 0.01)
    }

    func testYPositionBottomString() {
        let style = TablatureStyle.default
        let note = TabNote(string: 0, fret: 0, time: 0.0)
        XCTAssertEqual(style.yPosition(for: note, stringCount: 6), 110, accuracy: 0.01)
    }

    // MARK: - Custom Style Overrides

    func testCustomMeasureWidthAffectsXPosition() {
        var style = TablatureStyle.default
        style.measureWidth = 600
        let measure = TabMeasure(duration: 4.0, notes: [
            TabNote(string: 0, fret: 0, time: 2.0)
        ])
        // usableWidth = 600 - 2*15 = 570, midpoint = 15 + 0.5*570 = 300
        let x = style.xPosition(for: measure.notes[0], in: measure)
        XCTAssertEqual(x, 300, accuracy: 0.01)
    }

    func testCustomStringSpacingAffectsStaffHeight() {
        var style = TablatureStyle.default
        style.stringSpacing = 30
        XCTAssertEqual(style.staffHeight(stringCount: 6), 150)
    }

    func testCustomVerticalPaddingAffectsTotal() {
        var style = TablatureStyle.default
        style.verticalPadding = 20
        // staffHeight(6) = 100, padding = 20 * 2 = 40
        XCTAssertEqual(style.totalHeight(stringCount: 6), 140)
    }

    func testCustomStringSpacingAffectsYPosition() {
        var style = TablatureStyle.default
        style.stringSpacing = 30
        style.verticalPadding = 5
        let note = TabNote(string: 0, fret: 0, time: 0.0)
        // y = 5 + (6-1-0)*30 = 5 + 150 = 155
        XCTAssertEqual(style.yPosition(for: note, stringCount: 6), 155, accuracy: 0.01)
    }

    func testInitWithAllCustomValues() {
        let style = TablatureStyle(
            labelColumnWidth: 40,
            stringSpacing: 25,
            measureWidth: 400,
            measureInset: 20,
            lineThickness: 2,
            verticalPadding: 15,
            fretColor: .blue,
            fretBackgroundColor: .white,
            labelColor: .gray,
            lineColor: .black
        )
        XCTAssertEqual(style.labelColumnWidth, 40)
        XCTAssertEqual(style.stringSpacing, 25)
        XCTAssertEqual(style.measureWidth, 400)
        XCTAssertEqual(style.measureInset, 20)
        XCTAssertEqual(style.lineThickness, 2)
        XCTAssertEqual(style.verticalPadding, 15)
        XCTAssertEqual(style.fretBackgroundColor, .white)
    }
}
