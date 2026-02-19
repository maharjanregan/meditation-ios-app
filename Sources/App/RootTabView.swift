import SwiftUI

struct RootTabView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        TabView(selection: $appState.selectedTab) {
            TodayView()
                .tabItem { Label("Today", systemImage: "sun.max") }
                .tag(AppTab.today)

            LearnView()
                .tabItem { Label("Learn", systemImage: "sparkles") }
                .tag(AppTab.learn)

            PracticeView()
                .tabItem { Label("Practice", systemImage: "circle.hexagongrid") }
                .tag(AppTab.practice)

            ReflectView()
                .tabItem { Label("Reflect", systemImage: "square.and.pencil") }
                .tag(AppTab.reflect)
        }
        .overlay(alignment: .bottom) {
            NowPlayingMiniBar()
                .padding(.horizontal)
                .padding(.bottom, 8)
        }
    }
}
