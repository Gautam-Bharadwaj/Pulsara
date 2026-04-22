import Foundation

struct JournalEntry: Identifiable, Codable, Equatable {
    let id: UUID
    var content: String
    var mood: String
    var date: Date
    var tags: [String]

    init(id: UUID = UUID(), content: String, mood: String, date: Date = Date(), tags: [String] = []) {
        self.id = id
        self.content = content
        self.mood = mood
        self.date = date
        self.tags = tags
    }
}

enum UserRole: String, Codable {
    case patient
    case inspector
}

final class AppDataStore: ObservableObject {
    @Published var entries: [JournalEntry] = [] {
        didSet { saveEntries() }
    }

    @Published var currentRole: UserRole? {
        didSet { saveSession() }
    }

    @Published var signedInEmail: String = "" {
        didSet { saveSession() }
    }

    @Published var notificationsEnabled: Bool = true {
        didSet { saveSettings() }
    }

    @Published var passcodeEnabled: Bool = false {
        didSet { saveSettings() }
    }

    private let entriesKey = "pulsara.entries"
    private let roleKey = "pulsara.currentRole"
    private let emailKey = "pulsara.email"
    private let notificationsKey = "pulsara.notificationsEnabled"
    private let passcodeKey = "pulsara.passcodeEnabled"

    init() {
        loadEntries()
        loadSession()
        loadSettings()
    }

    var recentEntries: [JournalEntry] {
        entries.sorted { $0.date > $1.date }
    }

    var exportText: String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601

        guard let data = try? encoder.encode(recentEntries),
              let text = String(data: data, encoding: .utf8) else {
            return "[]"
        }

        return text
    }

    func signIn(role: String, email: String) {
        currentRole = UserRole(rawValue: role) ?? .patient
        signedInEmail = email.isEmpty ? demoEmail(for: role) : email
    }

    func signOut() {
        currentRole = nil
        signedInEmail = ""
    }

    func addEntry(content: String, mood: String, tags: [String], date: Date = Date()) {
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedContent.isEmpty else { return }

        entries.insert(
            JournalEntry(content: trimmedContent, mood: mood, date: date, tags: tags),
            at: 0
        )
    }

    func entries(on date: Date) -> [JournalEntry] {
        entries
            .filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
            .sorted { $0.date > $1.date }
    }

    func moodCount(for mood: String, inLastDays days: Int = 7) -> Int {
        let calendar = Calendar.current
        guard let startDate = calendar.date(byAdding: .day, value: -(days - 1), to: calendar.startOfDay(for: Date())) else {
            return 0
        }

        return entries.filter { $0.mood == mood && $0.date >= startDate }.count
    }

    func entryCount(on date: Date) -> Int {
        entries(on: date).count
    }

    func topTags(limit: Int = 8) -> [(name: String, count: Int)] {
        let counts = entries
            .flatMap(\.tags)
            .reduce(into: [String: Int]()) { result, tag in
                result[tag.capitalized, default: 0] += 1
            }

        return counts
            .sorted { lhs, rhs in
                lhs.value == rhs.value ? lhs.key < rhs.key : lhs.value > rhs.value
            }
            .prefix(limit)
            .map { (name: $0.key, count: $0.value) }
    }

    private func demoEmail(for role: String) -> String {
        role == "inspector" ? "inspector@pulsara.demo" : "patient@pulsara.demo"
    }

    private func loadEntries() {
        guard let data = UserDefaults.standard.data(forKey: entriesKey) else { return }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        entries = (try? decoder.decode([JournalEntry].self, from: data)) ?? []
    }

    private func saveEntries() {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        guard let data = try? encoder.encode(entries) else { return }
        UserDefaults.standard.set(data, forKey: entriesKey)
    }

    private func loadSession() {
        if let roleValue = UserDefaults.standard.string(forKey: roleKey) {
            currentRole = UserRole(rawValue: roleValue)
        }
        signedInEmail = UserDefaults.standard.string(forKey: emailKey) ?? ""
    }

    private func saveSession() {
        UserDefaults.standard.set(currentRole?.rawValue, forKey: roleKey)
        UserDefaults.standard.set(signedInEmail, forKey: emailKey)
    }

    private func loadSettings() {
        if UserDefaults.standard.object(forKey: notificationsKey) != nil {
            notificationsEnabled = UserDefaults.standard.bool(forKey: notificationsKey)
        }
        if UserDefaults.standard.object(forKey: passcodeKey) != nil {
            passcodeEnabled = UserDefaults.standard.bool(forKey: passcodeKey)
        }
    }

    private func saveSettings() {
        UserDefaults.standard.set(notificationsEnabled, forKey: notificationsKey)
        UserDefaults.standard.set(passcodeEnabled, forKey: passcodeKey)
    }
}
