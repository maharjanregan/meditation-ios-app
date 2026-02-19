import SwiftUI

struct ReflectView: View {
    @Environment(ThemeStore.self) private var themeStore
    @EnvironmentObject private var reflections: ReflectionStore
    @EnvironmentObject private var library: SessionLibraryStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    JMCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Gentle reflection")
                                .font(.title2)
                                .foregroundStyle(themeStore.theme.textPrimary)
                            Text("No grades. Just noticing how you related to experience.")
                                .foregroundStyle(themeStore.theme.textSecondary)
                        }
                    }

                    NavigationLink {
                        NewReflectionView()
                    } label: {
                        Text("Write a reflection")
                    }
                    .buttonStyle(JMPrimaryButtonStyle())

                    if reflections.entries.isEmpty {
                        JMCard {
                            Text("No reflections yet. If you want, start with: ‘What did I notice?’")
                                .foregroundStyle(themeStore.theme.textSecondary)
                        }
                    } else {
                        ForEach(reflections.entries) { entry in
                            JMCard {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(sessionTitle(for: entry.sessionId))
                                        .font(.headline)
                                        .foregroundStyle(themeStore.theme.textPrimary)
                                    Text(entry.date.formatted(date: .abbreviated, time: .shortened))
                                        .font(.caption)
                                        .foregroundStyle(themeStore.theme.textSecondary)

                                    ForEach(entry.promptAnswers.keys.sorted(), id: \.self) { key in
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(key)
                                                .font(.caption)
                                                .foregroundStyle(themeStore.theme.textSecondary)
                                            Text(entry.promptAnswers[key] ?? "")
                                                .foregroundStyle(themeStore.theme.textPrimary)
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Spacer(minLength: 24)
                }
                .padding(16)
            }
            .background(themeStore.theme.background)
            .navigationTitle("Reflect")
        }
    }

    private func sessionTitle(for id: String) -> String {
        library.session(id: id)?.title ?? "Session"
    }
}

struct NewReflectionView: View {
    @Environment(ThemeStore.self) private var themeStore
    @EnvironmentObject private var reflections: ReflectionStore
    @EnvironmentObject private var library: SessionLibraryStore
    @Environment(\.dismiss) private var dismiss

    @State private var selectedSessionId: String = ""
    @State private var notice: String = ""
    @State private var easy: String = ""
    @State private var difficult: String = ""

    var body: some View {
        Form {
            Section("Session") {
                Picker("Session", selection: $selectedSessionId) {
                    Text("None").tag("")
                    ForEach(library.catalog.sessions.prefix(30), id: \.id) { s in
                        Text(s.title).tag(s.id)
                    }
                }
            }

            Section("Prompts") {
                TextField("What did you notice?", text: $notice, axis: .vertical)
                TextField("What felt easy?", text: $easy, axis: .vertical)
                TextField("What felt difficult, and how did you relate to it?", text: $difficult, axis: .vertical)
            }

            Section {
                Button("Save") {
                    let entry = ReflectionEntry(sessionId: selectedSessionId.isEmpty ? "unknown" : selectedSessionId,
                                              promptAnswers: [
                                                "What did you notice?": notice,
                                                "What felt easy?": easy,
                                                "What felt difficult, and how did you relate to it?": difficult
                                              ])
                    reflections.add(entry)
                    dismiss()
                }
                .buttonStyle(JMPrimaryButtonStyle())
            }
        }
        .navigationTitle("New reflection")
        .background(themeStore.theme.background)
    }
}
