import SwiftUI

struct CalendarView: View {
    @EnvironmentObject private var store: AppDataStore
    @State private var selectedDate = Date()

    private var selectedEntries: [JournalEntry] {
        store.entries(on: selectedDate)
    }

    var body: some View {
        NavigationStack {
            PulsaraScreen {
                ScrollView(showsIndicators: false) {
                    LazyVStack(alignment: .leading, spacing: 22) {
                        Text("Calendar")
                            .font(.largeTitle.weight(.bold))
                            .foregroundColor(PulsaraTheme.textPrimary)
                            .padding(.top, 18)

                        PulsaraCard {
                            DatePicker("Select Date", selection: $selectedDate, displayedComponents: [.date])
                                .datePickerStyle(.graphical)
                                .tint(PulsaraTheme.primary)
                                .colorScheme(.dark)
                                .accessibilityLabel("Select journal date")
                        }

                        VStack(alignment: .leading, spacing: 14) {
                            SectionTitle(title: selectedDate.formatted(date: .long, time: .omitted))

                            if selectedEntries.isEmpty {
                                PulsaraCard {
                                    EmptyStateView(
                                        icon: "calendar.badge.clock",
                                        title: "No entries on this date",
                                        message: "Entries saved on this day will appear here."
                                    )
                                }
                            } else {
                                ForEach(selectedEntries) { entry in
                                    JournalEntryCard(entry: entry)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 90)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
            .environmentObject(AppDataStore())
    }
}
