import SwiftUI

struct JournalEntryView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var content: String = ""
    @State private var selectedMood: String = "Good"
    @State private var tags: String = ""
    
    let moods = [
        ("🤩", "Rad"),
        ("🙂", "Good"),
        ("😐", "Meh"),
        ("😔", "Bad"),
        ("😫", "Awful")
    ]
    
    var body: some View {
        ZStack {
            PulsaraTheme.background.ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Text("New Entry")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                    Button(action: {
                        // Save Entry
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Save")
                            .font(.headline)
                            .foregroundColor(PulsaraTheme.primary)
                    }
                }
                .padding()

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Mood Picker
                        VStack(alignment: .leading, spacing: 12) {
                            Text("How's your mood?")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            HStack(spacing: 12) {
                                ForEach(moods, id: \.1) { mood in
                                    MoodOption(emoji: mood.0, name: mood.1, isSelected: selectedMood == mood.1) {
                                        selectedMood = mood.1
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)

                        // Content Editor
                        VStack(alignment: .leading, spacing: 12) {
                            Text("What's on your mind?")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            TextEditor(text: $content)
                                .frame(height: 200)
                                .padding(12)
                                .background(PulsaraTheme.surface)
                                .cornerRadius(16)
                                .foregroundColor(.white)
                                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray.opacity(0.1)))
                        }
                        .padding(.horizontal)

                        // Tags
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Tags (comma separated)")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            TextField("e.g. work, happy, tired", text: $tags)
                                .padding()
                                .background(PulsaraTheme.surface)
                                .cornerRadius(12)
                                .foregroundColor(.white)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.1)))
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct MoodOption: View {
    let emoji: String
    let name: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(emoji)
                    .font(.system(size: 28))
                Text(name)
                    .font(.caption2)
                    .foregroundColor(isSelected ? .black : PulsaraTheme.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(isSelected ? PulsaraTheme.primary : PulsaraTheme.surface)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? PulsaraTheme.primary : Color.gray.opacity(0.1), lineWidth: 1)
            )
        }
    }
}

struct JournalEntryView_Previews: PreviewProvider {
    static var previews: some View {
        JournalEntryView()
    }
}
