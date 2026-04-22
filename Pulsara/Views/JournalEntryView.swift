import SwiftUI

struct JournalEntryView: View {
    @EnvironmentObject private var store: AppDataStore
    @Environment(\.dismiss) private var dismiss
    @State private var content = ""
    @State private var selectedMood = "Good"
    @State private var tags = ""
    @FocusState private var isEditorFocused: Bool
    @Namespace private var moodNamespace

    private var parsedTags: [String] {
        tags
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
            .filter { !$0.isEmpty }
    }

    private var canSave: Bool {
        !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        PulsaraScreen {
            VStack(spacing: 0) {
                header

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 22) {
                        VStack(alignment: .leading, spacing: 14) {
                            SectionTitle(title: "Mood")
                            MoodSelector(selectedMood: $selectedMood, namespace: moodNamespace)
                        }

                        journalCard
                        tagsCard
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 18)
                }
            }
        }
        .navigationBarHidden(true)
    }

    private var header: some View {
        HStack(spacing: 12) {
            Button {
                Haptics.impact(.light)
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(PulsaraTheme.textPrimary)
                    .frame(width: 40, height: 40)
                    .background(Circle().fill(PulsaraTheme.surfaceLight))
            }
            .buttonStyle(PressableScaleButtonStyle())
            .accessibilityLabel("Close journal entry")

            Spacer()

            Text("New Entry")
                .font(.headline)
                .foregroundColor(PulsaraTheme.textPrimary)

            Spacer()

            Button {
                saveEntry()
            } label: {
                Text("Save")
                    .font(.subheadline.weight(.bold))
                    .foregroundColor(canSave ? PulsaraTheme.background : PulsaraTheme.textDim)
                    .padding(.horizontal, 16)
                    .frame(height: 40)
                    .background(
                        Capsule().fill(canSave ? AnyShapeStyle(PulsaraTheme.brandGradient) : AnyShapeStyle(PulsaraTheme.surfaceLight))
                    )
            }
            .disabled(!canSave)
            .buttonStyle(PressableScaleButtonStyle())
            .accessibilityLabel("Save journal entry")
        }
        .padding(.horizontal, 20)
        .padding(.top, 14)
        .padding(.bottom, 8)
    }

    private var journalCard: some View {
        PulsaraCard {
            VStack(alignment: .leading, spacing: 14) {
                Label("Thoughts", systemImage: "square.and.pencil")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(PulsaraTheme.primary)

                ZStack(alignment: .topLeading) {
                    if content.isEmpty {
                        Text("Write what happened, what you felt, and what you need next.")
                            .foregroundColor(PulsaraTheme.textDim)
                            .font(.body)
                            .padding(.top, 10)
                            .padding(.leading, 6)
                    }

                    TextEditor(text: $content)
                        .scrollContentBackground(.hidden)
                        .focused($isEditorFocused)
                        .frame(minHeight: 220)
                        .foregroundColor(PulsaraTheme.textPrimary)
                        .tint(PulsaraTheme.primary)
                        .background(Color.clear)
                        .accessibilityLabel("Journal thoughts")
                }
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(isEditorFocused ? PulsaraTheme.primary.opacity(0.45) : Color.clear, lineWidth: 1)
        )
        .animation(.easeInOut(duration: 0.18), value: isEditorFocused)
    }

    private var tagsCard: some View {
        PulsaraCard {
            VStack(alignment: .leading, spacing: 12) {
                Label("Tags", systemImage: "tag.fill")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(PulsaraTheme.primary)

                TextField("work, sleep, family", text: $tags)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding(14)
                    .foregroundColor(PulsaraTheme.textPrimary)
                    .tint(PulsaraTheme.primary)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(PulsaraTheme.surfaceLight)
                    )
                    .accessibilityLabel("Entry tags")
            }
        }
    }

    private func saveEntry() {
        guard canSave else { return }
        Haptics.notify(.success)
        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
            store.addEntry(content: content, mood: selectedMood, tags: parsedTags)
        }
        dismiss()
    }
}

struct JournalEntryView_Previews: PreviewProvider {
    static var previews: some View {
        JournalEntryView()
            .environmentObject(AppDataStore())
    }
}
