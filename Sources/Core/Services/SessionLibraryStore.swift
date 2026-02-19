import Foundation
import SwiftUI

@MainActor
final class SessionLibraryStore: ObservableObject {
    static let shared = SessionLibraryStore()

    @Published private(set) var catalog: SessionCatalog = SessionCatalog(version: 1, sessions: [])
    @Published private(set) var isLoaded: Bool = false
    @Published private(set) var loadError: String? = nil

    private init() {
        Task { await load() }
    }

    func load() async {
        do {
            // Expect `Resources/Sessions/catalog.json` in app bundle.
            guard let url = Bundle.main.url(forResource: "catalog", withExtension: "json", subdirectory: "Sessions")
            else {
                throw NSError(domain: "SessionLibraryStore", code: 404, userInfo: [NSLocalizedDescriptionKey: "Missing Sessions/catalog.json in bundle."])
            }

            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let decoded = try decoder.decode(SessionCatalog.self, from: data)

            self.catalog = decoded
            self.isLoaded = true
            self.loadError = nil
        } catch {
            self.isLoaded = false
            self.loadError = String(describing: error)
        }
    }

    func sessions(of type: PracticeType, mode: SessionMode? = nil) -> [Session] {
        catalog.sessions
            .filter { $0.practiceType == type }
            .filter { mode == nil ? true : $0.mode == mode }
            .sorted { $0.durationSeconds < $1.durationSeconds }
    }

    func session(id: String) -> Session? {
        catalog.sessions.first { $0.id == id }
    }

    func todaysPick() -> Session? {
        // Simple deterministic pick: rotate based on day-of-year.
        let allGuided = catalog.sessions.filter { $0.mode == .guided && $0.durationSeconds <= 8 * 60 }
        guard !allGuided.isEmpty else { return nil }
        let day = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        return allGuided[day % allGuided.count]
    }
}
