import Foundation
import SwiftUI

struct ReflectionEntry: Codable, Identifiable, Hashable {
    let id: String
    let date: Date
    let sessionId: String
    let promptAnswers: [String: String]

    init(date: Date = Date(), sessionId: String, promptAnswers: [String: String]) {
        self.id = UUID().uuidString
        self.date = date
        self.sessionId = sessionId
        self.promptAnswers = promptAnswers
    }
}

@MainActor
final class ReflectionStore: ObservableObject {
    static let shared = ReflectionStore()

    @Published private(set) var entries: [ReflectionEntry] = []

    private let storageKey = "reflectionEntriesV1"

    private init() {
        load()
    }

    func add(_ entry: ReflectionEntry) {
        entries.insert(entry, at: 0)
        save()
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return }
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            entries = try decoder.decode([ReflectionEntry].self, from: data)
        } catch {
            entries = []
        }
    }

    private func save() {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(entries)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            // best-effort
        }
    }
}
