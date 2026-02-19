import Foundation
import SwiftUI
import AVFoundation

@MainActor
final class PlayerStore: ObservableObject {
    static let shared = PlayerStore()

    @Published var activeSession: Session? = nil
    @Published var isPlaying: Bool = false
    @Published var elapsed: TimeInterval = 0
    @Published var showPlayerSheet: Bool = false

    // Settings
    @AppStorage("playbackRate") var playbackRate: Double = 1.0
    @AppStorage("ambientEnabled") var ambientEnabled: Bool = false
    @AppStorage("bellsEnabled") var bellsEnabled: Bool = false

    private var timer: Timer? = nil
    private var startDate: Date? = nil

    private init() {}

    func start(session: Session) {
        activeSession = session
        elapsed = 0
        showPlayerSheet = true
        play()
    }

    func play() {
        guard activeSession != nil else { return }
        isPlaying = true
        startDate = Date()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { [weak self] _ in
            guard let self else { return }
            guard self.isPlaying else { return }
            guard let startDate = self.startDate else { return }
            self.elapsed = Date().timeIntervalSince(startDate)
        }
    }

    func pause() {
        isPlaying = false
        timer?.invalidate()
        timer = nil
    }

    func stop() {
        pause()
        activeSession = nil
        elapsed = 0
        showPlayerSheet = false
    }

    func groundingExitText() -> [String] {
        [
            "Open your eyes if they’re closed.",
            "Feel your feet on the floor.",
            "Name three things you can see.",
            "Take one slow breath.",
            "If you want, you can stop the session. That’s a good choice."
        ]
    }
}
