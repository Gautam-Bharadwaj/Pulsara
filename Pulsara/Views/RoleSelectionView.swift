import SwiftUI

struct RoleSelectionView: View {
    var body: some View {
        NavigationStack {
            PulsaraScreen {
                VStack(spacing: 34) {
                    Spacer(minLength: 26)
                    brandHeader
                    roleSection
                    Spacer()
                    footer
                }
                .padding(.horizontal, 22)
            }
            .navigationBarHidden(true)
        }
    }

    private var brandHeader: some View {
        VStack(spacing: 18) {
            Image(systemName: "waveform.path.ecg")
                .font(.system(size: 46, weight: .semibold))
                .foregroundStyle(PulsaraTheme.brandGradient)
                .frame(width: 86, height: 86)
                .background(Circle().fill(PulsaraTheme.primary.opacity(0.12)))
                .accessibilityHidden(true)

            VStack(spacing: 8) {
                Text("PULSARA")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .tracking(4)
                    .foregroundColor(PulsaraTheme.textPrimary)
                    .minimumScaleFactor(0.8)
                Text("A calm bridge between patients and wellness inspectors")
                    .font(.subheadline)
                    .foregroundColor(PulsaraTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 12)
            }
        }
    }

    private var roleSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionTitle(title: "Continue as")
            RoleCard(
                icon: "person.fill",
                title: "Patient",
                description: "Track mood, write reflections, and review your progress.",
                role: "patient"
            )
            RoleCard(
                icon: "stethoscope",
                title: "Inspector",
                description: "Monitor assigned patients and identify early support needs.",
                role: "inspector"
            )
        }
    }

    private var footer: some View {
        Text("By continuing, you agree to the privacy and care guidelines.")
            .font(.caption)
            .foregroundColor(PulsaraTheme.textTertiary)
            .multilineTextAlignment(.center)
            .padding(.bottom, 18)
    }
}

struct RoleCard: View {
    let icon: String
    let title: String
    let description: String
    let role: String

    var body: some View {
        NavigationLink(destination: SignInView(role: role)) {
            PulsaraCard(cornerRadius: 24) {
                HStack(spacing: 16) {
                    Image(systemName: icon)
                        .font(.title3.weight(.semibold))
                        .foregroundColor(PulsaraTheme.primary)
                        .frame(width: 52, height: 52)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(PulsaraTheme.primary.opacity(0.12))
                        )

                    VStack(alignment: .leading, spacing: 5) {
                        Text(title)
                            .font(.headline)
                            .foregroundColor(PulsaraTheme.textPrimary)
                        Text(description)
                            .font(.subheadline)
                            .foregroundColor(PulsaraTheme.textSecondary)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    }

                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.bold))
                        .foregroundColor(PulsaraTheme.textTertiary)
                }
            }
        }
        .buttonStyle(PressableScaleButtonStyle())
        .simultaneousGesture(TapGesture().onEnded { Haptics.impact(.light) })
        .accessibilityLabel("Continue as \(title)")
    }
}

struct RoleSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        RoleSelectionView()
            .environmentObject(AppDataStore())
    }
}
