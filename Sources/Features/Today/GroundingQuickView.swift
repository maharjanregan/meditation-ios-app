import SwiftUI

struct GroundingQuickView: View {
    @Environment(ThemeStore.self) private var themeStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                JMCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Grounding reset")
                            .font(.title2)
                            .foregroundStyle(themeStore.theme.textPrimary)

                        Text("If things feel too intense, it’s okay to pause. This is a short, practical reset.")
                            .foregroundStyle(themeStore.theme.textSecondary)
                    }
                }

                ForEach(steps, id: \.self) { step in
                    JMCard {
                        Text(step)
                            .foregroundStyle(themeStore.theme.textPrimary)
                    }
                }

                JMCard {
                    Text("If this keeps happening, consider reaching out to a mental health professional. Meditation is supportive, but it isn’t a replacement for care.")
                        .foregroundStyle(themeStore.theme.textSecondary)
                }

                Spacer(minLength: 24)
            }
            .padding(16)
        }
        .background(themeStore.theme.background)
        .navigationTitle("Grounding")
    }

    private var steps: [String] {
        [
            "1) Open your eyes. Let the room be here.",
            "2) Feel your feet on the floor. Notice pressure and contact.",
            "3) Name three things you can see.",
            "4) Gently lengthen one exhale.",
            "5) If you want, stop and come back later. That’s wise, not failure."
        ]
    }
}
