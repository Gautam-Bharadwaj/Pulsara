import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var store: AppDataStore
    @State private var showingExport = false

    var body: some View {
        NavigationStack {
            PulsaraScreen {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 20) {
                        HStack {
                            Text("Settings")
                                .font(.largeTitle.weight(.bold))
                                .foregroundColor(PulsaraTheme.textPrimary)
                            Spacer()
                        }
                        .padding(.top, 18)

                        profileCard
                        settingsCard
                        logoutButton
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 90)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingExport) {
                ExportDataView(exportText: store.exportText)
            }
        }
    }

    private var profileCard: some View {
        PulsaraCard {
            HStack(spacing: 16) {
                Text("JP")
                    .font(.headline.weight(.bold))
                    .foregroundColor(PulsaraTheme.background)
                    .frame(width: 58, height: 58)
                    .background(Circle().fill(PulsaraTheme.brandGradient))
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 5) {
                    Text("John Patient")
                        .font(.headline)
                        .foregroundColor(PulsaraTheme.textPrimary)
                    Text(store.signedInEmail.isEmpty ? "patient@pulsara.demo" : store.signedInEmail)
                        .font(.subheadline)
                        .foregroundColor(PulsaraTheme.textSecondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.78)
                }
                Spacer()
            }
        }
        .accessibilityElement(children: .combine)
    }

    private var settingsCard: some View {
        PulsaraCard {
            VStack(spacing: 4) {
                SettingsToggleRow(icon: "bell.fill", title: "Notifications", isOn: $store.notificationsEnabled)
                Divider().background(PulsaraTheme.textDim.opacity(0.35))
                SettingsToggleRow(icon: "lock.fill", title: "Passcode Lock", isOn: $store.passcodeEnabled)
                Divider().background(PulsaraTheme.textDim.opacity(0.35))
                SettingsActionRow(icon: "doc.text.fill", title: "Export Data") {
                    Haptics.impact(.light)
                    showingExport = true
                }
                Divider().background(PulsaraTheme.textDim.opacity(0.35))
                SettingsActionRow(icon: "star.fill", title: "Rate Pulsara") {
                    Haptics.impact(.light)
                }
                Divider().background(PulsaraTheme.textDim.opacity(0.35))
                SettingsActionRow(icon: "questionmark.circle.fill", title: "Help & Support") {
                    Haptics.impact(.light)
                }
            }
        }
    }

    private var logoutButton: some View {
        Button {
            Haptics.impact(.medium)
            store.signOut()
        } label: {
            Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                .font(.headline)
                .foregroundColor(PulsaraTheme.critical)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(PulsaraTheme.surface)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(PulsaraTheme.critical.opacity(0.18), lineWidth: 1)
                        )
                )
        }
        .buttonStyle(PressableScaleButtonStyle())
        .accessibilityLabel("Logout")
    }
}

struct SettingsToggleRow: View {
    let icon: String
    let title: String
    @Binding var isOn: Bool

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .foregroundColor(PulsaraTheme.primary)
                .frame(width: 28)
            Text(title)
                .font(.body.weight(.medium))
                .foregroundColor(PulsaraTheme.textPrimary)
            Spacer()
            Toggle(title, isOn: $isOn)
                .labelsHidden()
                .tint(PulsaraTheme.primary)
                .onChange(of: isOn) { _ in Haptics.impact(.light) }
        }
        .padding(.vertical, 12)
        .accessibilityElement(children: .combine)
    }
}

struct SettingsActionRow: View {
    let icon: String
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .foregroundColor(PulsaraTheme.primary)
                    .frame(width: 28)
                Text(title)
                    .font(.body.weight(.medium))
                    .foregroundColor(PulsaraTheme.textPrimary)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundColor(PulsaraTheme.textTertiary)
            }
            .padding(.vertical, 12)
        }
        .buttonStyle(PressableScaleButtonStyle())
        .accessibilityLabel(title)
    }
}

struct ExportDataView: View {
    let exportText: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            PulsaraScreen {
                ScrollView {
                    Text(exportText)
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(PulsaraTheme.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(20)
                }
            }
            .navigationTitle("Export Data")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .foregroundColor(PulsaraTheme.primary)
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(AppDataStore())
    }
}
