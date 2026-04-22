import SwiftUI

struct PatientListView: View {
    @EnvironmentObject private var store: AppDataStore
    @State private var searchQuery = ""

    private let patients = [
        Patient(name: "Aarav Patel", status: "Stable", lastCheckIn: "2 hours ago", mood: "good"),
        Patient(name: "Diya Sharma", status: "Needs Attention", lastCheckIn: "1 day ago", mood: "bad"),
        Patient(name: "Vihaan Singh", status: "Improving", lastCheckIn: "5 hours ago", mood: "meh"),
        Patient(name: "Ananya Gupta", status: "Stable", lastCheckIn: "10 mins ago", mood: "rad"),
        Patient(name: "Ishaan Kumar", status: "Critical", lastCheckIn: "30 mins ago", mood: "awful")
    ]

    private var filteredPatients: [Patient] {
        let query = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return patients }
        return patients.filter {
            $0.name.localizedCaseInsensitiveContains(query) ||
            $0.status.localizedCaseInsensitiveContains(query) ||
            $0.mood.localizedCaseInsensitiveContains(query)
        }
    }

    var body: some View {
        NavigationStack {
            PulsaraScreen {
                ScrollView(showsIndicators: false) {
                    LazyVStack(alignment: .leading, spacing: 20) {
                        header
                        searchField
                        overviewCards

                        VStack(alignment: .leading, spacing: 14) {
                            SectionTitle(title: "Assigned patients")
                            if filteredPatients.isEmpty {
                                PulsaraCard {
                                    EmptyStateView(
                                        icon: "person.crop.circle.badge.questionmark",
                                        title: "No matching patients",
                                        message: "Try searching by name, mood, or status."
                                    )
                                }
                            } else {
                                ForEach(filteredPatients) { patient in
                                    PatientCard(patient: patient)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 18)
                    .padding(.bottom, 90)
                }
            }
            .navigationBarHidden(true)
        }
    }

    private var header: some View {
        HStack(alignment: .center, spacing: 14) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Inspector")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(PulsaraTheme.textPrimary)
                Text("Monitor patient wellness signals")
                    .font(.subheadline)
                    .foregroundColor(PulsaraTheme.textSecondary)
            }
            Spacer()
            Button {
                Haptics.impact(.medium)
                store.signOut()
            } label: {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(PulsaraTheme.critical)
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(PulsaraTheme.surfaceLight))
            }
            .buttonStyle(PressableScaleButtonStyle())
            .accessibilityLabel("Exit inspector mode")
        }
    }

    private var searchField: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(PulsaraTheme.textTertiary)
            TextField("Search patients", text: $searchQuery)
                .foregroundColor(PulsaraTheme.textPrimary)
                .tint(PulsaraTheme.primary)
                .textInputAutocapitalization(.words)
            if !searchQuery.isEmpty {
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        searchQuery = ""
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(PulsaraTheme.textTertiary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Clear search")
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(PulsaraTheme.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Color.white.opacity(0.07), lineWidth: 1)
                )
        )
    }

    private var overviewCards: some View {
        HStack(spacing: 12) {
            InspectorMetric(title: "Patients", value: "\(patients.count)", color: PulsaraTheme.primary)
            InspectorMetric(title: "Needs care", value: "\(patients.filter { $0.mood == "bad" || $0.mood == "awful" }.count)", color: PulsaraTheme.critical)
        }
    }
}

struct InspectorMetric: View {
    let title: String
    let value: String
    let color: Color

    var body: some View {
        PulsaraCard(cornerRadius: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text(value)
                    .font(.title2.weight(.bold))
                    .foregroundColor(color)
                Text(title)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(PulsaraTheme.textTertiary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .accessibilityElement(children: .combine)
    }
}

struct PatientCard: View {
    let patient: Patient

    var body: some View {
        let mood = MoodOptionData.option(for: patient.mood.capitalized)

        PulsaraCard(cornerRadius: 22) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(mood.color.opacity(0.14))
                    Text(String(patient.name.prefix(1)))
                        .font(.headline.weight(.bold))
                        .foregroundColor(mood.color)
                }
                .frame(width: 54, height: 54)
                .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 6) {
                    Text(patient.name)
                        .font(.headline)
                        .foregroundColor(PulsaraTheme.textPrimary)
                        .lineLimit(1)
                    Label(patient.lastCheckIn, systemImage: "clock")
                        .font(.caption)
                        .foregroundColor(PulsaraTheme.textTertiary)
                }

                Spacer(minLength: 10)

                VStack(alignment: .trailing, spacing: 8) {
                    StatusBadge(status: patient.status, mood: patient.mood)
                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.bold))
                        .foregroundColor(PulsaraTheme.textDim)
                }
            }
        }
        .accessibilityElement(children: .combine)
    }
}

struct Patient: Identifiable {
    let id = UUID()
    let name: String
    let status: String
    let lastCheckIn: String
    let mood: String
}

struct PatientListView_Previews: PreviewProvider {
    static var previews: some View {
        PatientListView()
            .environmentObject(AppDataStore())
    }
}
