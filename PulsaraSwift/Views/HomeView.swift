import SwiftUI

struct HomeView: View {
    @State private var greeting = ""
    @State private var dateString = ""
    @State private var entries: [JournalEntry] = []
    
    var body: some View {
        NavigationView {
            ZStack {
                PulsaraTheme.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Header
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(greeting), John Patient")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text(dateString)
                                .font(.subheadline)
                                .foregroundColor(PulsaraTheme.textSecondary)
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)

                        // Daily Prompt
                        VStack(alignment: .leading, spacing: 8) {
                            Text("DAILY REFLECTION")
                                .font(.caption.bold())
                                .foregroundColor(PulsaraTheme.primary)
                                .tracking(1.2)
                            
                            Text("\"How are you feeling today?\"")
                                .font(.system(size: 18, weight: .medium, design: .serif))
                                .italic()
                                .foregroundColor(.white)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(PulsaraTheme.surface)
                        .cornerRadius(16)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray.opacity(0.1)))
                        .padding(.horizontal)

                        // Mood Check-in
                        VStack(alignment: .leading, spacing: 12) {
                            Text("How are you feeling?")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            HStack(spacing: 15) {
                                MoodButton(emoji: "🤩", name: "Rad")
                                MoodButton(emoji: "🙂", name: "Good")
                                MoodButton(emoji: "😐", name: "Meh")
                                MoodButton(emoji: "😔", name: "Bad")
                                MoodButton(emoji: "😫", name: "Awful")
                            }
                            .padding()
                            .background(PulsaraTheme.surface)
                            .cornerRadius(20)
                            .padding(.horizontal)
                        }

                        // Recent Entries
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Recent Entries")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            if entries.isEmpty {
                                VStack(spacing: 12) {
                                    Text("📔")
                                        .font(.system(size: 64))
                                    Text("Your journal is empty.")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Text("Tap the button below to start writing.")
                                        .font(.subheadline)
                                        .foregroundColor(PulsaraTheme.textSecondary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 40)
                            }
                        }
                    }
                }
                
                // Floating Action Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "plus")
                                .font(.title.bold())
                                .foregroundColor(.black)
                                .frame(width: 60, height: 60)
                                .background(PulsaraTheme.primary)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                        .padding()
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            updateGreeting()
        }
    }
    
    private func updateGreeting() {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 12 { greeting = "Good Morning" }
        else if hour < 18 { greeting = "Good Afternoon" }
        else { greeting = "Good Evening" }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        dateString = formatter.string(from: Date())
    }
}

struct MoodButton: View {
    let emoji: String
    let name: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(emoji)
                .font(.system(size: 30))
            Text(name)
                .font(.caption)
                .foregroundColor(PulsaraTheme.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct JournalEntry: Identifiable {
    let id = UUID()
    let mood: String
    let content: String
    let date: Date
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
