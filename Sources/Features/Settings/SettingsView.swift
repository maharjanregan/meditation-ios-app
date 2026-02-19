import SwiftUI

struct SettingsView: View {
    @Environment(ThemeStore.self) private var themeStore
    @EnvironmentObject private var player: PlayerStore

    @AppStorage("prefersHighContrast") private var prefersHighContrast: Bool = false

    var body: some View {
        Form {
            Section("Appearance") {
                Toggle("High contrast", isOn: $prefersHighContrast)
                Text("Respects system text size and reduced motion settings.")
                    .font(.caption)
                    .foregroundStyle(themeStore.theme.textSecondary)
            }

            Section("Audio") {
                Toggle("Ambient sound (optional)", isOn: $player.ambientEnabled)
                Toggle("Gentle bells", isOn: $player.bellsEnabled)
                VStack(alignment: .leading) {
                    Text("Playback speed")
                    Slider(value: $player.playbackRate, in: 0.85...1.15, step: 0.05) {
                        Text("Playback speed")
                    }
                    Text(String(format: "%.2fx", player.playbackRate))
                        .font(.caption)
                        .foregroundStyle(themeStore.theme.textSecondary)
                }
            }

            Section("Safety") {
                Text("Meditation is not a replacement for therapy. If you’re experiencing severe distress, consider professional support.")
                    .foregroundStyle(themeStore.theme.textSecondary)
            }
        }
        .navigationTitle("Settings")
        .background(themeStore.theme.background)
    }
}
