import SwiftUI

struct HomeView: View {
    @State private var greeting = ""
    @State private var dateString = ""
    @State private var entries: [JournalEntry] = []
    
    var body: some View {
        TabView {
            // Home Tab
            NavigationView {
                ZStack {
                    PulsaraTheme.background.ignoresSafeArea()
                    
                    // Background Glow
                    Circle()
                        .fill(PulsaraTheme.primary.opacity(0.05))
                        .frame(width: 400, height: 400)
                        .blur(radius: 80)
                        .offset(x: 100, y: -200)

                    ScrollView {
                        VStack(alignment: .leading, spacing: 32) {
                            // Header
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("\(greeting), John")
                                        .font(.system(size: 28, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    Text(dateString)
                                        .font(.subheadline)
                                        .foregroundColor(PulsaraTheme.textSecondary)
                                }
                                Spacer()
                                Image(systemName: "person.circle.fill")
                                    .font(.system(size: 40))
                                    .foregroundStyle(PulsaraTheme.goldGradient)
                            }
                            .padding(.horizontal)
                            .padding(.top, 20)

                            // Premium Quote Card
                            ZStack {
                                RoundedRectangle(cornerRadius: 32)
                                    .fill(PulsaraTheme.goldGradient.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 32)
                                            .stroke(PulsaraTheme.primary.opacity(0.2), lineWidth: 1)
                                    )
                                
                                VStack(alignment: .leading, spacing: 16) {
                                    HStack {
                                        Image(systemName: "quote.opening")
                                            .foregroundColor(PulsaraTheme.primary)
                                        Spacer()
                                    }
                                    
                                    Text("The only journey is the one within.")
                                        .font(.system(size: 20, weight: .medium, design: .serif))
                                        .italic()
                                        .foregroundColor(.white)
                                        .lineSpacing(4)
                                    
                                    HStack {
                                        Spacer()
                                        Text("- Rainer Maria Rilke")
                                            .font(.caption)
                                            .foregroundColor(PulsaraTheme.textSecondary)
                                    }
                                }
                                .padding(24)
                            }
                            .padding(.horizontal)

                            // Mood Check-in
                            VStack(alignment: .leading, spacing: 20) {
                                Text("HOW ARE YOU FEELING?")
                                    .font(.caption.bold())
                                    .foregroundColor(PulsaraTheme.textDim)
                                    .tracking(2)
                                    .padding(.horizontal)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        MoodCard(emoji: "🤩", name: "Rad")
                                        MoodCard(emoji: "🙂", name: "Good")
                                        MoodCard(emoji: "😐", name: "Meh")
                                        MoodCard(emoji: "😔", name: "Bad")
                                        MoodCard(emoji: "😫", name: "Awful")
                                    }
                                    .padding(.horizontal)
                                }
                            }

                            // Recent Activity
                            VStack(alignment: .leading, spacing: 20) {
                                HStack {
                                    Text("RECENT ENTRIES")
                                        .font(.caption.bold())
                                        .foregroundColor(PulsaraTheme.textDim)
                                        .tracking(2)
                                    Spacer()
                                    Button("View All") { }
                                        .font(.caption.bold())
                                        .foregroundColor(PulsaraTheme.primary)
                                }
                                .padding(.horizontal)
                                
                                if entries.isEmpty {
                                    VStack(spacing: 16) {
                                        Image(systemName: "book.closed.fill")
                                            .font(.system(size: 50))
                                            .foregroundStyle(Color.white.opacity(0.05))
                                        
                                        Text("Your sanctuary is empty.")
                                            .font(.headline)
                                            .foregroundColor(PulsaraTheme.textSecondary)
                                        
                                        Text("Start your journey by adding your first thought.")
                                            .font(.caption)
                                            .foregroundColor(PulsaraTheme.textDim)
                                            .multilineTextAlignment(.center)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 40)
                                    .background(RoundedRectangle(cornerRadius: 24).fill(Color.white.opacity(0.02)))
                                    .padding(.horizontal)
                                }
                            }
                        }
                        .padding(.bottom, 100)
                    }
                    
                    // Floating Action Button
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            NavigationLink(destination: JournalEntryView()) {
                                ZStack {
                                    Circle()
                                        .fill(PulsaraTheme.goldGradient)
                                        .frame(width: 64, height: 64)
                                        .shadow(color: PulsaraTheme.primary.opacity(0.4), radius: 15, x: 0, y: 8)
                                    
                                    Image(systemName: "plus")
                                        .font(.title.bold())
                                        .foregroundColor(.black)
                                }
                            }
                            .padding(24)
                            .padding(.bottom, 60)
                        }
                    }
                }
                .navigationBarHidden(true)
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }

            CalendarView()
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }

            StatsView()
                .tabItem {
                    Label("Stats", systemImage: "chart.bar.fill")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .accentColor(PulsaraTheme.primary)
        .onAppear {
            updateGreeting()
            UITabBar.appearance().backgroundColor = UIColor(PulsaraTheme.background)
            UITabBar.appearance().unselectedItemTintColor = UIColor(PulsaraTheme.textDim)
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

struct MoodCard: View {
    let emoji: String
    let name: String
    
    var body: some View {
        VStack(spacing: 12) {
            Text(emoji)
                .font(.system(size: 32))
            Text(name)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
        }
        .frame(width: 80, height: 100)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.03))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
        )
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
