import SwiftUI

struct NowPlayingMiniBar: View {
    @Environment(ThemeStore.self) private var themeStore
    @EnvironmentObject private var player: PlayerStore

    var body: some View {
        if let session = player.activeSession {
            Button {
                player.showPlayerSheet = true
            } label: {
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(session.title)
                            .font(.subheadline)
                            .foregroundStyle(themeStore.theme.textPrimary)
                            .lineLimit(1)
                        Text("\(session.practiceType.displayName) • \(session.durationSeconds/60) min")
                            .font(.caption)
                            .foregroundStyle(themeStore.theme.textSecondary)
                            .lineLimit(1)
                    }
                    Spacer()
                    Image(systemName: player.isPlaying ? "pause.fill" : "play.fill")
                        .foregroundStyle(themeStore.theme.accent)
                        .accessibilityLabel(player.isPlaying ? "Pause" : "Play")
                }
                .padding(12)
                .background(themeStore.theme.surface)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 8)
            }
            .buttonStyle(.plain)
            .sheet(isPresented: $player.showPlayerSheet) {
                PlayerSheetView()
            }
        }
    }
}

struct PlayerSheetView: View {
    @Environment(ThemeStore.self) private var themeStore
    @EnvironmentObject private var player: PlayerStore

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                if let session = player.activeSession {
                    Text(session.title)
                        .font(.title2)
                        .foregroundStyle(themeStore.theme.textPrimary)
                        .multilineTextAlignment(.center)

                    Text("\(session.practiceType.displayName) • \(session.mode.displayName) • \(session.durationSeconds/60) min")
                        .foregroundStyle(themeStore.theme.textSecondary)

                    JMCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("If the mind wanders, that’s not a problem. Noticing that it wandered is the practice.")
                                .foregroundStyle(themeStore.theme.textSecondary)

                            if session.mode == .guided {
                                Text("Captions")
                                    .font(.headline)
                                    .foregroundStyle(themeStore.theme.textPrimary)
                                TranscriptView(session: session)
                            } else {
                                Text("Reminder")
                                    .font(.headline)
                                    .foregroundStyle(themeStore.theme.textPrimary)
                                UnguidedReminderView(session: session)
                            }
                        }
                    }

                    HStack(spacing: 12) {
                        Button {
                            player.isPlaying ? player.pause() : player.play()
                        } label: {
                            Text(player.isPlaying ? "Pause" : "Play")
                        }
                        .buttonStyle(JMPrimaryButtonStyle())

                        Button {
                            player.stop()
                        } label: {
                            Text("Stop")
                        }
                        .buttonStyle(JMSecondaryButtonStyle())
                    }

                    JMCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Grounding")
                                .font(.headline)
                                .foregroundStyle(themeStore.theme.textPrimary)
                            ForEach(player.groundingExitText(), id: \.self) { line in
                                Text("• \(line)")
                                    .foregroundStyle(themeStore.theme.textSecondary)
                            }
                        }
                    }

                    Spacer()
                } else {
                    Text("No session")
                        .foregroundStyle(themeStore.theme.textSecondary)
                }
            }
            .padding(16)
            .background(themeStore.theme.background)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink { SettingsView() } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
        }
    }
}

struct TranscriptView: View {
    @Environment(ThemeStore.self) private var themeStore
    let session: Session

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(Array((session.transcript ?? []).enumerated()), id: \.offset) { _, block in
                    switch block {
                    case .text(let t):
                        Text(t)
                            .foregroundStyle(themeStore.theme.textPrimary)
                    case .pause(let seconds):
                        Text("(quiet for \(seconds)s)")
                            .font(.caption)
                            .foregroundStyle(themeStore.theme.textSecondary)
                    }
                }
            }
        }
        .frame(maxHeight: 220)
        .accessibilityLabel("Captions")
    }
}

struct UnguidedReminderView: View {
    @Environment(ThemeStore.self) private var themeStore
    let session: Session

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(session.onScreenReminders ?? ["You can let everything be here.", "Noticing is the practice."], id: \.self) { line in
                Text("• \(line)")
                    .foregroundStyle(themeStore.theme.textSecondary)
            }
        }
        .accessibilityLabel("Unguided reminders")
    }
}
