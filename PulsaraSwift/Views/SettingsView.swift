import SwiftUI

struct SettingsView: View {
    var body: some View {
        ZStack {
            PulsaraTheme.background.ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
                HStack {
                    Text("Settings")
                        .font(.title.bold())
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 20)

                ScrollView {
                    VStack(spacing: 20) {
                        // Profile Section
                        HStack(spacing: 16) {
                            Circle()
                                .fill(PulsaraTheme.primary)
                                .frame(width: 60, height: 60)
                                .overlay(Text("JP").font(.headline).foregroundColor(.black))
                            
                            VStack(alignment: .leading) {
                                Text("John Patient")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("patient@dummy.com")
                                    .font(.subheadline)
                                    .foregroundColor(PulsaraTheme.textSecondary)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(PulsaraTheme.surface)
                        .cornerRadius(20)

                        // Settings List
                        VStack(spacing: 1) {
                            SettingsRow(icon: "bell", title: "Notifications", toggle: true)
                            SettingsRow(icon: "lock", title: "Passcode Lock", toggle: false)
                            SettingsRow(icon: "doc.text", title: "Export Data")
                            SettingsRow(icon: "star", title: "Rate Pulsara")
                            SettingsRow(icon: "questionmark.circle", title: "Help & Support")
                        }
                        .background(PulsaraTheme.surface)
                        .cornerRadius(20)
                        
                        // Logout
                        Button(action: {}) {
                            Text("Logout")
                                .font(.headline)
                                .foregroundColor(PulsaraTheme.error)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(PulsaraTheme.surface)
                                .cornerRadius(20)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    var toggle: Bool? = nil
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .foregroundColor(PulsaraTheme.primary)
                .frame(width: 24)
            
            Text(title)
                .foregroundColor(.white)
            
            Spacer()
            
            if let _ = toggle {
                Toggle("", isOn: .constant(true)) // Simplified
            } else {
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(PulsaraTheme.textDim)
            }
        }
        .padding()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
