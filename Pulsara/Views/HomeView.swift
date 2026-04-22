import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var store: AppDataStore
    @State private var greeting = ""
    @State private var dateString = ""
    @State private var selectedMood = "Good"
    @State private var showingJournal = false
    @Namespace private var moodNamespace

    var body: some View {
        TabView {
            NavigationStack {
                PulsaraScreen {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(alignment: .leading, spacing: 24) {
                            header
                            reflectionCard
                            quickMoodCheckIn
                            recentEntries
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 18)
                        .padding(.bottom, 110)
                    }
                    .overlay(alignment: .bottomTrailing) {
                        addEntryButton
                    }
                }
                .navigationBarHidden(true)
                .sheet(isPresented: $showingJournal) {
                    NavigationStack {
                        JournalEntryView()
                            .environmentObject(store)
                    }
                }
            }
            .tabItem { Label("Home", systemImage: "house.fill") }

            CalendarView()
                .tabItem { Label("Calendar", systemImage: "calendar") }

            StatsView()
                .tabItem { Label("Stats", systemImage: "chart.bar.fill") }

            SettingsView()
                .tabItem { Label("Settings", systemImage: "gearshape.fill") }
        }
        .tint(PulsaraTheme.primary)
        .onAppear {
            updateGreeting()
            UITabBar.appearance().backgroundColor = UIColor(PulsaraTheme.background)
            UITabBar.appearance().unselectedItemTintColor = UIColor(PulsaraTheme.textDim)
        }
    }

    private var header: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text(greeting)
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(PulsaraTheme.textPrimary)
                    .minimumScaleFactor(0.75)
                Text(dateString)
                    .font(.subheadline)
                    .foregroundColor(PulsaraTheme.textSecondary)
            }
            Spacer()
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 42, weight: .semibold))
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(PulsaraTheme.primary)
                .accessibilityLabel("Patient profile")
        }
    }

    private var reflectionCard: some View {
        PulsaraCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Label("Daily Reflection", systemImage: "sparkle.magnifyingglass")
                        .font(.footnote.weight(.semibold))
                        .foregroundColor(PulsaraTheme.primary)
                    Spacer()
                }
                Text("What is one feeling you noticed today, and what might it be trying to tell you?")
                    .font(.title3.weight(.semibold))
                    .foregroundColor(PulsaraTheme.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)
                Text("Use your journal to slow down and capture the context around your mood.")
                    .font(.subheadline)
                    .foregroundColor(PulsaraTheme.textTertiary)
            }
        }
    }

    private var quickMoodCheckIn: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionTitle(title: "Mood check-in")
            MoodSelector(selectedMood: $selectedMood, namespace: moodNamespace) { mood in
                withAnimation(.spring(response: 0.35, dampingFraction: 0.82)) {
                    store.addEntry(content: "Mood check-in: \(mood)", mood: mood, tags: ["check-in"])
                }
            }
        }
    }

    private var recentEntries: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionTitle(title: "Recent entries")

            if store.recentEntries.isEmpty {
                PulsaraCard {
                    EmptyStateView(
                        icon: "book.closed.fill",
                        title: "No entries yet",
                        message: "Start with a short mood check-in or write a journal entry."
                    )
                }
            } else {
                ForEach(store.recentEntries.prefix(5)) { entry in
                    JournalEntryCard(entry: entry)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
        }
        .animation(.spring(response: 0.38, dampingFraction: 0.84), value: store.recentEntries.count)
    }

    private var addEntryButton: some View {
        Button {
            Haptics.impact(.medium)
            showingJournal = true
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(PulsaraTheme.background)
                .frame(width: 62, height: 62)
                .background(Circle().fill(PulsaraTheme.brandGradient))
                .shadow(color: PulsaraTheme.primary.opacity(0.32), radius: 18, x: 0, y: 10)
        }
        .buttonStyle(PressableScaleButtonStyle())
        .padding(.trailing, 22)
        .padding(.bottom, 88)
        .accessibilityLabel("Create journal entry")
    }

    private func updateGreeting() {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 12 {
            greeting = "Good Morning"
        } else if hour < 18 {
            greeting = "Good Afternoon"
        } else {
            greeting = "Good Evening"
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        dateString = formatter.string(from: Date())
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AppDataStore())
    }
}
