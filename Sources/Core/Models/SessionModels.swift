import Foundation

enum PracticeType: String, Codable, CaseIterable, Identifiable {
    case awareness
    case body
    case kindness
    case openAwareness

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .awareness: return "Awareness"
        case .body: return "Body-based"
        case .kindness: return "Kindness"
        case .openAwareness: return "Open awareness"
        }
    }

    var shortDescription: String {
        switch self {
        case .awareness:
            return "Recognize that awareness is already here. Thoughts are allowed."
        case .body:
            return "Use sensation as an anchor. Grounding, steady, safe."
        case .kindness:
            return "A gentle attitude practice. No forced positivity."
        case .openAwareness:
            return "Rest with experience as it unfolds. Effortless, spacious."
        }
    }
}

enum SessionMode: String, Codable, CaseIterable, Identifiable {
    case guided
    case unguided

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .guided: return "Guided"
        case .unguided: return "Unguided"
        }
    }
}

struct Session: Codable, Identifiable, Hashable {
    let id: String
    let title: String
    let practiceType: PracticeType
    let durationSeconds: Int
    let mode: SessionMode

    /// For guided sessions.
    let transcript: [TranscriptBlock]?

    /// For unguided sessions.
    let onScreenReminders: [String]?

    let safety: SafetyMetadata

    struct SafetyMetadata: Codable, Hashable {
        let hasGroundingExit: Bool
        let disclaimer: String
    }
}

enum TranscriptBlock: Codable, Hashable {
    case text(String)
    case pause(seconds: Int)

    private enum CodingKeys: String, CodingKey { case type, value, seconds }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        switch type {
        case "text":
            let value = try container.decode(String.self, forKey: .value)
            self = .text(value)
        case "pause":
            let seconds = try container.decode(Int.self, forKey: .seconds)
            self = .pause(seconds: seconds)
        default:
            throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Unknown transcript block type")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .text(let value):
            try container.encode("text", forKey: .type)
            try container.encode(value, forKey: .value)
        case .pause(let seconds):
            try container.encode("pause", forKey: .type)
            try container.encode(seconds, forKey: .seconds)
        }
    }
}

struct SessionCatalog: Codable {
    let version: Int
    let sessions: [Session]
}
