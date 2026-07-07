import Tonic
import XCTest

final class PitchTests: XCTestCase {

    func noteSort(lhs: Note, rhs: Note) -> Bool {
        lhs.description < rhs.description
    }

    func testEnharmonicNotes() {
        var notes = Pitch(60).enharmonicNotes()
        XCTAssertEqual(notes, [Note.Bs, Note.C])

        notes = Pitch(61).enharmonicNotes().sorted(by: noteSort)
        XCTAssertEqual(notes, [Note.Db, Note.Cs].sorted(by: noteSort))
    }

    func testEnharmonicNotesWithTheoretical() {
        // C
        var notes = Pitch(60).enharmonicNotes(allowTheoretical: true).sorted(by: noteSort)
        XCTAssertEqual(
            notes,
            [
                Note.C,
                Note(.B, accidental: .sharp),
                Note(.D, accidental: .doubleFlat),
            ].sorted(by: noteSort))

        // F
        notes = Pitch(65).enharmonicNotes(allowTheoretical: true).sorted(by: noteSort)
        XCTAssertEqual(
            notes,
            [
                Note.F,
                Note(.E, accidental: .sharp),
                Note(.G, accidental: .doubleFlat),
            ].sorted(by: noteSort))

        // Eb
        notes = Pitch(63).enharmonicNotes(allowTheoretical: true).sorted(by: noteSort)
        XCTAssertEqual(
            notes,
            [
                Note.Eb,
                Note(.D, accidental: .sharp),
                Note(.F, accidental: .doubleFlat),
            ].sorted(by: noteSort))

        // F#
        notes = Pitch(66).enharmonicNotes(allowTheoretical: true).sorted(by: noteSort)
        XCTAssertEqual(
            notes,
            [
                Note.Gb,
                Note(.F, accidental: .sharp),
                Note(.E, accidental: .doubleSharp),
            ].sorted(by: noteSort))

        // C#
        notes = Pitch(61).enharmonicNotes(allowTheoretical: true).sorted(by: noteSort)
        XCTAssertEqual(
            notes,
            [
                Note.Db,
                Note(.C, accidental: .sharp),
                Note(.B, accidental: .doubleSharp),
            ].sorted(by: noteSort))
    }
}
