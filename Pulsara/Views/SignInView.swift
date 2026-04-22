import SwiftUI

struct SignInView: View {
    let role: String
    @EnvironmentObject private var store: AppDataStore
    @Environment(\.dismiss) private var dismiss
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @FocusState private var focusedField: Field?

    private enum Field {
        case email
        case password
    }

    private var roleTitle: String {
        role == "inspector" ? "Inspector Portal" : "Patient Space"
    }

    private var canSignIn: Bool {
        email.contains("@") && password.count >= 4
    }

    var body: some View {
        PulsaraScreen {
            VStack(spacing: 28) {
                header
                Spacer(minLength: 10)
                titleBlock
                authCard
                Spacer()
            }
            .padding(.horizontal, 22)
            .padding(.top, 14)
        }
        .navigationBarHidden(true)
    }

    private var header: some View {
        HStack {
            Button {
                Haptics.impact(.light)
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(PulsaraTheme.textPrimary)
                    .frame(width: 42, height: 42)
                    .background(Circle().fill(PulsaraTheme.surfaceLight))
            }
            .buttonStyle(PressableScaleButtonStyle())
            .accessibilityLabel("Back")
            Spacer()
        }
    }

    private var titleBlock: some View {
        VStack(spacing: 10) {
            Image(systemName: role == "inspector" ? "stethoscope" : "heart.text.square.fill")
                .font(.system(size: 34, weight: .semibold))
                .foregroundStyle(PulsaraTheme.brandGradient)
                .frame(width: 72, height: 72)
                .background(Circle().fill(PulsaraTheme.primary.opacity(0.12)))
                .accessibilityHidden(true)
            Text(roleTitle)
                .font(.largeTitle.weight(.bold))
                .foregroundColor(PulsaraTheme.textPrimary)
                .multilineTextAlignment(.center)
            Text(role == "inspector" ? "Review patient wellness with clarity." : "Continue your daily self-care routine.")
                .font(.subheadline)
                .foregroundColor(PulsaraTheme.textSecondary)
                .multilineTextAlignment(.center)
        }
    }

    private var authCard: some View {
        PulsaraCard {
            VStack(spacing: 18) {
                PulsaraTextField(
                    icon: "envelope.fill",
                    placeholder: "Email",
                    text: $email,
                    isSecure: false,
                    isFocused: focusedField == .email
                )
                .focused($focusedField, equals: .email)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()

                PulsaraTextField(
                    icon: "lock.fill",
                    placeholder: "Password",
                    text: $password,
                    isSecure: true,
                    isFocused: focusedField == .password
                )
                .focused($focusedField, equals: .password)

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(PulsaraTheme.critical)
                        .multilineTextAlignment(.center)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }

                Button {
                    signIn()
                } label: {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(canSignIn ? PulsaraTheme.background : PulsaraTheme.textDim)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(canSignIn ? AnyShapeStyle(PulsaraTheme.brandGradient) : AnyShapeStyle(PulsaraTheme.surfaceLight))
                        )
                }
                .buttonStyle(PressableScaleButtonStyle())

                HStack(spacing: 12) {
                    Rectangle().fill(PulsaraTheme.textDim.opacity(0.35)).frame(height: 1)
                    Text("Demo Access")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(PulsaraTheme.textTertiary)
                    Rectangle().fill(PulsaraTheme.textDim.opacity(0.35)).frame(height: 1)
                }

                Button {
                    Haptics.notify(.success)
                    store.signIn(role: role, email: "")
                } label: {
                    Label("Enter Demo Account", systemImage: "arrow.right.circle.fill")
                        .font(.headline)
                        .foregroundColor(PulsaraTheme.textPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(PulsaraTheme.surfaceLight)
                        )
                }
                .buttonStyle(PressableScaleButtonStyle())
            }
        }
    }

    private func signIn() {
        guard canSignIn else {
            Haptics.notify(.error)
            withAnimation(.spring(response: 0.28, dampingFraction: 0.82)) {
                errorMessage = "Enter a valid email and a password with at least 4 characters."
            }
            return
        }
        Haptics.notify(.success)
        store.signIn(role: role, email: email)
    }
}

struct PulsaraTextField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    let isSecure: Bool
    let isFocused: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(isFocused ? PulsaraTheme.primary : PulsaraTheme.textTertiary)
                .frame(width: 24)
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .foregroundColor(PulsaraTheme.textPrimary)
            .tint(PulsaraTheme.primary)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(PulsaraTheme.surfaceLight)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(isFocused ? PulsaraTheme.primary.opacity(0.55) : Color.white.opacity(0.05), lineWidth: 1)
                )
        )
        .animation(.easeInOut(duration: 0.18), value: isFocused)
        .accessibilityLabel(placeholder)
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(role: "patient")
            .environmentObject(AppDataStore())
    }
}
