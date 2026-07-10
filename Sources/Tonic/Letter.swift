// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Tonic/

import Foundation

/// The alphabet used to spell all traditional music notes.
///
/// These letters can be modified by adding an ``Accidental`` to describe any ``NoteClass``.
/// And by specificying an octave, you can create any ``Note``.
public enum Letter: Int, Sendable, CaseIterable, Equatable, Hashable, Codable {
    case C, D, E, F, G, A, B

    static var count: Int = { Letter.allCases.count }()

    var baseNote: UInt8 {
        switch self {
        case .C: return 0
        case .D: return 2
        case .E: return 4
        case .F: return 5
        case .G: return 7
        case .A: return 9
        case .B: return 11
        }
    }
}

extension Letter: CustomStringConvertible {
    public var description: String {
        switch self {
            case .C:
                return "C"
            case .D:
                return "D"
            case .E:
                return "E"
            case .F:
                return "F"
            case .G:
                return "G"
            case .A:
                return "A"
            case .B:
                return "B"
        }
    }
}

extension Letter: Comparable {
    public static func < (lhs: Letter, rhs: Letter) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
