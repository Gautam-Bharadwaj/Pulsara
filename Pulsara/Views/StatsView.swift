import SwiftUI

struct StatsView: View {
    @EnvironmentObject private var store: AppDataStore

    private var lastSevenDays: [Date] {
        (0..<7).compactMap { offset in
            Calendar.current.date(byAdding: .day, value: offset - 6, to: Date())
        }
    }

    private var maxEntryCount: Int {
        max(lastSevenDays.map { store.entryCount(on: $0) }.max() ?? 1, 1)
    }

    var body: some View {
        NavigationStack {
            PulsaraScreen {
                ScrollView(showsIndicators: false) {
                    LazyVStack(alignment: .leading, spacing: 24) {
                        Text("Your Progress")
                            .font(.largeTitle.weight(.bold))
                            .foregroundColor(PulsaraTheme.textPrimary)
                            .padding(.top, 18)

                        weeklyMoodCard
                        tagsCard
                        summaryCard
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 90)
                }
            }
            .navigationBarHidden(true)
        }
    }

    private var weeklyMoodCard: some View {
        PulsaraCard {
            VStack(alignment: .leading, spacing: 18) {
                SectionTitle(title: "Last 7 days")

                HStack(alignment: .bottom, spacing: 12) {
                    ForEach(lastSevenDays, id: \.self) { date in
                        let count = store.entryCount(on: date)
                        let height = CGFloat(max(18, Int((Double(count) / Double(maxEntryCount)) * 110)))

                        VStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(count == 0 ? PulsaraTheme.surfaceLight : PulsaraTheme.brandGradient)
                                .frame(height: height)
                                .frame(maxWidth: .infinity)
                                .animation(.spring(response: 0.4, dampingFraction: 0.82), value: count)
                            Text(date.formatted(.dateTime.weekday(.narrow)))
                                .font(.caption2.weight(.semibold))
                                .foregroundColor(PulsaraTheme.textTertiary)
                        }
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("\(count) entries on \(date.formatted(date: .abbreviated, time: .omitted))")
                    }
                }
                .frame(height: 150)
            }
        }
    }

    private var tagsCard: some View {
        PulsaraCard {
            VStack(alignment: .leading, spacing: 16) {
                SectionTitle(title: "Most used tags")

                let tags = store.topTags()
                if tags.isEmpty {
                    Text("Tags from saved journal entries will appear here.")
                        .font(.subheadline)
                        .foregroundColor(PulsaraTheme.textTertiary)
                } else {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 110), spacing: 10)], alignment: .leading, spacing: 10) {
                        ForEach(tags, id: \.name) { tag in
                            TagPill(name: tag.name, count: tag.count)
                        }
                    }
                }
            }
        }
    }

    private var summaryCard: some View {
        PulsaraCard {
            HStack(spacing: 16) {
                StatTile(title: "Entries", value: "\(store.entries.count)", icon: "book.pages.fill")
                Divider().background(PulsaraTheme.textDim)
                StatTile(title: "Check-ins", value: "\(store.entries.filter { $0.tags.contains("check-in") }.count)", icon: "heart.text.square.fill")
            }
        }
    }
}

struct StatTile: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(PulsaraTheme.primary)
            Text(value)
                .font(.title2.weight(.bold))
                .foregroundColor(PulsaraTheme.textPrimary)
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundColor(PulsaraTheme.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
    }
}

struct TagPill: View {
    let name: String
    let count: Int

    var body: some View {
        HStack(spacing: 8) {
            Text(name)
                .lineLimit(1)
            Text("\(count)")
                .font(.caption.weight(.bold))
                .foregroundColor(PulsaraTheme.background)
                .padding(.horizontal, 7)
                .padding(.vertical, 3)
                .background(Capsule().fill(PulsaraTheme.primary))
        }
        .font(.subheadline.weight(.semibold))
        .foregroundColor(PulsaraTheme.textPrimary)
        .padding(.horizontal, 12)
        .padding(.vertical, 9)
        .background(Capsule().fill(PulsaraTheme.surfaceLight))
        .accessibilityLabel("Tag \(name), used \(count) times")
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
            .environmentObject(AppDataStore())
    }
}
