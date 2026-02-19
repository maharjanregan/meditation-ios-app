import SwiftUI

struct LearnView: View {
    @Environment(ThemeStore.self) private var themeStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    JMCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Meditation, demystified")
                                .font(.title2)
                                .foregroundStyle(themeStore.theme.textPrimary)

                            Text("Meditation is a trainable skill. If your mind wanders, that’s not failure—it’s the moment the skill gets trained.")
                                .foregroundStyle(themeStore.theme.textSecondary)
                        }
                    }

                    ForEach(learnCards, id: \.title) { card in
                        JMCard {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(card.title)
                                    .font(.headline)
                                    .foregroundStyle(themeStore.theme.textPrimary)
                                Text(card.body)
                                    .foregroundStyle(themeStore.theme.textSecondary)
                            }
                        }
                    }
                }
                .padding(16)
            }
            .background(themeStore.theme.background)
            .navigationTitle("Learn")
        }
    }

    private var learnCards: [(title: String, body: String)] {
        [
            (
                title: "Awareness is already here",
                body: "You don’t have to create awareness. The fact that you can notice anything—sound, thought, sensation—means awareness is already present."
            ),
            (
                title: "Distraction is not a problem",
                body: "A wandering mind is normal. Noticing you wandered is the key moment. That noticing is the practice."
            ),
            (
                title: "Thoughts aren’t enemies",
                body: "The goal is not to remove thoughts. The goal is to relate to them differently—more space, less struggle."
            ),
            (
                title: "Short counts",
                body: "Three minutes practiced often can change your relationship with your mind more than long sessions done rarely."
            )
        ]
    }
}
