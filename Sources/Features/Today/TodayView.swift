import SwiftUI

struct TodayView: View {
    @Environment(ThemeStore.self) private var themeStore
    @EnvironmentObject private var library: SessionLibraryStore
    @EnvironmentObject private var player: PlayerStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    header

                    JMCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("A small practice")
                                .font(.title2)
                                .foregroundStyle(themeStore.theme.textPrimary)

                            Text("Short is powerful. If your mind is busy, that’s okay. We’ll work with it.")
                                .foregroundStyle(themeStore.theme.textSecondary)

                            if library.isLoaded, let pick = library.todaysPick() {
                                sessionRow(pick)
                            } else if let err = library.loadError {
                                Text("Couldn't load sessions: \(err)")
                                    .foregroundStyle(.red)
                            } else {
                                Text("Loading…")
                                    .foregroundStyle(themeStore.theme.textSecondary)
                            }
                        }
                    }

                    JMCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("If you feel overwhelmed")
                                .font(.title3)
                                .foregroundStyle(themeStore.theme.textPrimary)
                            Text("You can stop at any time. Grounding is also practice.")
                                .foregroundStyle(themeStore.theme.textSecondary)

                            NavigationLink {
                                GroundingQuickView()
                            } label: {
                                Text("Open a 2‑minute grounding reset")
                            }
                            .buttonStyle(JMSecondaryButtonStyle())
                        }
                    }

                    JMCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("No pressure")
                                .font(.title3)
                                .foregroundStyle(themeStore.theme.textPrimary)
                            Text("There are no streaks here. Coming back is the win.")
                                .foregroundStyle(themeStore.theme.textSecondary)
                        }
                    }

                    Spacer(minLength: 20)
                }
                .padding(16)
            }
            .background(themeStore.theme.background)
            .navigationTitle("Today")
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Hi, Regan")
                .font(.largeTitle)
                .foregroundStyle(themeStore.theme.textPrimary)
            Text("Let’s keep it simple.")
                .foregroundStyle(themeStore.theme.textSecondary)
        }
        .accessibilityElement(children: .combine)
    }

    private func sessionRow(_ session: Session) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(session.title)
                .font(.headline)
                .foregroundStyle(themeStore.theme.textPrimary)

            Text("\(session.practiceType.displayName) • \(session.mode.displayName) • \(session.durationSeconds / 60) min")
                .font(.subheadline)
                .foregroundStyle(themeStore.theme.textSecondary)

            Button {
                player.start(session: session)
            } label: {
                Text("Start")
            }
            .buttonStyle(JMPrimaryButtonStyle())
            .accessibilityHint("Starts the session")
        }
    }
}
