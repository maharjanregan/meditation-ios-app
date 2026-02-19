import SwiftUI

@main
struct ChillApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(appState)
                .environment(ThemeStore.shared)
                .environmentObject(SessionLibraryStore.shared)
                .environmentObject(ReflectionStore.shared)
                .environmentObject(PlayerStore.shared)
        }
    }
}
