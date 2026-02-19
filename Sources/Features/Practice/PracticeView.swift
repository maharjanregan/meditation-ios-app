import SwiftUI

struct PracticeView: View {
    @Environment(ThemeStore.self) private var themeStore
    @EnvironmentObject private var library: SessionLibraryStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    JMCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Choose a practice")
                                .font(.title2)
                                .foregroundStyle(themeStore.theme.textPrimary)
                            Text("There’s no single right way. Start small and keep it kind.")
                                .foregroundStyle(themeStore.theme.textSecondary)
                        }
                    }

                    ForEach(PracticeType.allCases) { type in
                        NavigationLink {
                            PracticeTypeDetailView(type: type)
                        } label: {
                            JMCard {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(type.displayName)
                                        .font(.headline)
                                        .foregroundStyle(themeStore.theme.textPrimary)
                                    Text(type.shortDescription)
                                        .foregroundStyle(themeStore.theme.textSecondary)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(16)
            }
            .background(themeStore.theme.background)
            .navigationTitle("Practice")
        }
    }
}

struct PracticeTypeDetailView: View {
    @Environment(ThemeStore.self) private var themeStore
    @EnvironmentObject private var library: SessionLibraryStore
    @EnvironmentObject private var player: PlayerStore

    let type: PracticeType

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                JMCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(type.displayName)
                            .font(.title2)
                            .foregroundStyle(themeStore.theme.textPrimary)
                        Text(type.shortDescription)
                            .foregroundStyle(themeStore.theme.textSecondary)
                    }
                }

                JMCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Guided")
                            .font(.headline)
                            .foregroundStyle(themeStore.theme.textPrimary)
                        sessionsList(library.sessions(of: type, mode: .guided))
                    }
                }

                JMCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Unguided")
                            .font(.headline)
                            .foregroundStyle(themeStore.theme.textPrimary)
                        sessionsList(library.sessions(of: type, mode: .unguided))
                    }
                }
            }
            .padding(16)
        }
        .background(themeStore.theme.background)
        .navigationTitle(type.displayName)
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private func sessionsList(_ sessions: [Session]) -> some View {
        if sessions.isEmpty {
            Text("No sessions found. Add them to Sessions/catalog.json")
                .foregroundStyle(themeStore.theme.textSecondary)
        } else {
            VStack(spacing: 10) {
                ForEach(sessions, id: \.id) { s in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(s.title)
                                .foregroundStyle(themeStore.theme.textPrimary)
                            Text("\(s.durationSeconds / 60) min")
                                .font(.caption)
                                .foregroundStyle(themeStore.theme.textSecondary)
                        }
                        Spacer()
                        Button("Start") { player.start(session: s) }
                            .buttonStyle(.bordered)
                    }
                    .accessibilityElement(children: .combine)
                }
            }
        }
    }
}
