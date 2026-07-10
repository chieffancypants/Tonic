// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Tonic/

import Foundation

/// The key is the set of notes that are played in a composition, or portion of a composition.
///
/// A key is composed of a Root ``Note``, and a ``Scale``.
public struct Key: Sendable, Equatable, Hashable {
    /// The primary note class of the key, also known as the tonic
    public let root: NoteClass

    /// The intervallic relations from the root note to all other notes in the key
    public let scale: Scale

    /// A note set containing all the notes in the key
    public let noteSet: NoteSet

    /// An ordered array of all NoteClasses present in the key
    // TODO: Remove noteSet above and switch to using this as it makes far more sense
    public var noteClasses = [NoteClass]()

    /// Initialize the key
    /// - Parameters:
    ///   - root: The primary note class of the key, also known as the tonic
    ///   - scale: The intervallic relations from the root note to all other notes in the key
    public init(root: NoteClass, scale: Scale = .major) {
        self.root = root
        self.scale = scale

        var r: [Note] = []
        for interval in scale.intervals {
            if let noteClass = root.canonicalNote.shiftUp(interval)?.noteClass {
                noteClasses.append(noteClass)
                r.append(noteClass.canonicalNote)
            }
        }
        noteSet = NoteSet(notes: r)
    }

    /// The type of accidental to use in this key
    public var preferredAccidental: Accidental {
        if root.accidental == .sharp {
            return .sharp
        }
        if root.accidental == .flat {
            return .flat
        }

        let naturalKeysWithFlats: [Key] = [.F, .d, .g, .c, .f]
        if naturalKeysWithFlats.contains(self) {
            return .flat
        }
        return .sharp
    }

    /// All chords that fit in the key
    public var chords: [Chord] {
        let table = ChordTable.shared
        var chords: [Chord] = []
        for (_, chord) in table.chords where chord.noteClassSet.isSubset(of: noteSet.noteClassSet) {
            chords.append(Chord(chord.root, type: chord.type))
        }
        return chords
    }

    /// All the traditional triads representable root, third, and fifth from each note in the key
    public var primaryTriads: [Chord] {
        let table = ChordTable.shared

        var chords: [Chord] = []
        var primaryTriads: [Chord] = []

        let allowablePrimaryTriads: [ChordType] = [.major, .minor, .dim, .aug]

        for (_, chord) in table.chords where chord.noteClassSet.isSubset(of: noteSet.noteClassSet) {
            chords.append(Chord(chord.root, type: chord.type))
            if allowablePrimaryTriads.contains(chord.type) {
                primaryTriads.append(Chord(chord.root, type: chord.type))
            }
        }

        let primaryTriadsStartingWithC = primaryTriads.sorted(by: { $0.root.letter < $1.root.letter })
        let rootPosition = primaryTriadsStartingWithC.firstIndex(where: { $0.root == root }) ?? 0
        return Array(primaryTriadsStartingWithC.rotatingLeft(positions: rootPosition))
    }
}


extension Key: Codable {
    enum CodingKeys:CodingKey {
        case root
        case scale
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let root = try container.decode(NoteClass.self, forKey: .root)
        let scale = try container.decode(Scale.self, forKey: .scale)
        self.init(root: root, scale: scale)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(root, forKey: .root)
        try container.encode(scale, forKey: .scale)
    }
}


extension RangeReplaceableCollection {
    func rotatingLeft(positions: Int) -> SubSequence {
        let index = self.index(startIndex, offsetBy: positions, limitedBy: endIndex) ?? endIndex
        return self[index...] + self[..<index]
    }
}
