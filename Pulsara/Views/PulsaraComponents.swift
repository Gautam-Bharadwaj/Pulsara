import SwiftUI

struct MoodOptionData: Identifiable, Equatable {
    let id: String
    let title: String
    let symbol: String
    let color: Color

    static let all: [MoodOptionData] = [
        MoodOptionData(id: "Rad", title: "Rad", symbol: "sun.max.fill", color: PulsaraTheme.success),
        MoodOptionData(id: "Good", title: "Good", symbol: "leaf.fill", color: PulsaraTheme.primary),
        MoodOptionData(id: "Meh", title: "Meh", symbol: "cloud.fill", color: PulsaraTheme.warning),
        MoodOptionData(id: "Bad", title: "Bad", symbol: "cloud.rain.fill", color: PulsaraTheme.critical.opacity(0.9)),
        MoodOptionData(id: "Awful", title: "Awful", symbol: "exclamationmark.triangle.fill", color: PulsaraTheme.critical)
    ]

    static func option(for title: String) -> MoodOptionData {
        all.first { $0.title.caseInsensitiveCompare(title) == .orderedSame } ?? all[1]
    }
}

struct PulsaraScreen<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        ZStack {
            PulsaraTheme.mainGradient.ignoresSafeArea()
            Circle()
                .fill(PulsaraTheme.primary.opacity(0.08))
                .frame(width: 360, height: 360)
                .blur(radius: 80)
                .offset(x: -170, y: -260)
                .accessibilityHidden(true)
            Circle()
                .fill(PulsaraTheme.accent.opacity(0.06))
                .frame(width: 320, height: 320)
                .blur(radius: 90)
                .offset(x: 180, y: 300)
                .accessibilityHidden(true)
            content
        }
        .preferredColorScheme(.dark)
    }
}

struct PulsaraCard<Content: View>: View {
    var cornerRadius: CGFloat = 24
    @ViewBuilder let content: Content

    var body: some View {
        content
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(PulsaraTheme.surface.opacity(0.88))
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .stroke(Color.white.opacity(0.07), lineWidth: 1)
                    )
            )
            .shadow(color: .black.opacity(0.18), radius: 18, x: 0, y: 10)
    }
}

struct SectionTitle: View {
    let title: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        HStack {
            Text(title)
                .font(.footnote.weight(.semibold))
                .foregroundColor(PulsaraTheme.textTertiary)
                .textCase(.uppercase)
                .tracking(1.1)
            Spacer()
            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .font(.footnote.weight(.semibold))
                    .foregroundColor(PulsaraTheme.primary)
                    .buttonStyle(.plain)
            }
        }
        .accessibilityElement(children: .combine)
    }
}

struct PressableScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .opacity(configuration.isPressed ? 0.86 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.78), value: configuration.isPressed)
    }
}

struct MoodSelector: View {
    @Binding var selectedMood: String
    var namespace: Namespace.ID?
    var onSelect: ((String) -> Void)? = nil

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 5)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(MoodOptionData.all) { mood in
                MoodButton(
                    mood: mood,
                    isSelected: selectedMood == mood.title,
                    namespace: namespace,
                    action: {
                        withAnimation(.spring(response: 0.32, dampingFraction: 0.78)) {
                            selectedMood = mood.title
                        }
                        Haptics.impact(.light)
                        onSelect?(mood.title)
                    }
                )
            }
        }
    }
}

private struct MoodButton: View {
    let mood: MoodOptionData
    let isSelected: Bool
    let namespace: Namespace.ID?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    if let namespace, isSelected {
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(mood.color.opacity(0.22))
                            .matchedGeometryEffect(id: "selectedMood", in: namespace)
                    }
                    Image(systemName: mood.symbol)
                        .font(.system(size: 19, weight: .semibold))
                        .foregroundColor(isSelected ? mood.color : PulsaraTheme.textSecondary)
                        .frame(width: 42, height: 42)
                }
                Text(mood.title)
                    .font(.caption2.weight(.semibold))
                    .foregroundColor(isSelected ? PulsaraTheme.textPrimary : PulsaraTheme.textSecondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity, minHeight: 82)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(isSelected ? PulsaraTheme.surfaceLight : PulsaraTheme.surface.opacity(0.75))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(isSelected ? mood.color.opacity(0.7) : Color.white.opacity(0.06), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PressableScaleButtonStyle())
        .accessibilityLabel("Mood \(mood.title)")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

struct JournalEntryCard: View {
    let entry: JournalEntry

    var body: some View {
        let mood = MoodOptionData.option(for: entry.mood)

        PulsaraCard(cornerRadius: 20) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 10) {
                    Image(systemName: mood.symbol)
                        .font(.footnote.weight(.bold))
                        .foregroundColor(mood.color)
                        .frame(width: 28, height: 28)
                        .background(Circle().fill(mood.color.opacity(0.14)))
                    Text(entry.mood)
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(PulsaraTheme.textPrimary)
                    Spacer()
                    Text(entry.date.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundColor(PulsaraTheme.textTertiary)
                }

                Text(entry.content)
                    .font(.body)
                    .foregroundColor(PulsaraTheme.textSecondary)
                    .lineLimit(4)
                    .fixedSize(horizontal: false, vertical: true)

                if !entry.tags.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(entry.tags, id: \.self) { tag in
                                Text(tag)
                                    .font(.caption.weight(.semibold))
                                    .foregroundColor(PulsaraTheme.primary)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(Capsule().fill(PulsaraTheme.primary.opacity(0.12)))
                            }
                        }
                    }
                }
            }
        }
        .accessibilityElement(children: .combine)
    }
}

struct StatusBadge: View {
    let status: String
    let mood: String

    private var color: Color {
        switch mood.lowercased() {
        case "rad", "good": return PulsaraTheme.success
        case "meh": return PulsaraTheme.warning
        case "bad": return PulsaraTheme.critical.opacity(0.9)
        case "awful": return PulsaraTheme.critical
        default: return PulsaraTheme.textTertiary
        }
    }

    var body: some View {
        Text(status)
            .font(.caption.weight(.semibold))
            .foregroundColor(color)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Capsule().fill(color.opacity(0.14)))
            .overlay(Capsule().stroke(color.opacity(0.25), lineWidth: 1))
            .accessibilityLabel("Status \(status)")
    }
}

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 34, weight: .semibold))
                .foregroundColor(PulsaraTheme.primary.opacity(0.75))
                .frame(width: 64, height: 64)
                .background(Circle().fill(PulsaraTheme.primary.opacity(0.1)))
            Text(title)
                .font(.headline)
                .foregroundColor(PulsaraTheme.textPrimary)
            Text(message)
                .font(.subheadline)
                .foregroundColor(PulsaraTheme.textTertiary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 34)
    }
}
