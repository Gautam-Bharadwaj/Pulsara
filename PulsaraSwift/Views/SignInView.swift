import SwiftUI

struct SignInView: View {
    let role: String
    @Environment(\.presentationMode) var presentationMode
    @State private var email = ""
    @State private var password = ""
    @State private var navigateToHome = false

    var body: some View {
        ZStack {
            PulsaraTheme.background.ignoresSafeArea()
            
            // Background Decor
            Circle()
                .fill(PulsaraTheme.primary.opacity(0.05))
                .frame(width: 300, height: 300)
                .blur(radius: 60)
                .offset(x: 100, y: -200)

            VStack(spacing: 32) {
                // Back Button & Header
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Circle().fill(Color.white.opacity(0.05)))
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 20)

                VStack(spacing: 12) {
                    Text("Welcome Back")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(role == "inspector" ? "Access the monitoring portal" : "Your mental sanctuary awaits")
                        .font(.subheadline)
                        .foregroundColor(PulsaraTheme.textSecondary)
                }

                // Glassmorphic Form
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 20) {
                        PremiumTextField(icon: "envelope.fill", placeholder: "Email", text: $email)
                        PremiumTextField(icon: "lock.fill", placeholder: "Password", text: $password, isSecure: true)
                    }
                    
                    Button(action: {
                        // Real login logic
                    }) {
                        Text("Sign In")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(PulsaraTheme.goldGradient)
                            .foregroundColor(.black)
                            .cornerRadius(16)
                            .shadow(color: PulsaraTheme.primary.opacity(0.3), radius: 10)
                    }
                    .padding(.top, 8)

                    HStack {
                        Rectangle().fill(Color.white.opacity(0.1)).frame(height: 1)
                        Text("OR").font(.caption2).foregroundColor(PulsaraTheme.textDim)
                        Rectangle().fill(Color.white.opacity(0.1)).frame(height: 1)
                    }

                    // Demo Login
                    Button(action: {
                        navigateToHome = true
                    }) {
                        HStack {
                            Image(systemName: "sparkles")
                                .foregroundStyle(PulsaraTheme.goldGradient)
                            Text("Try Demo Login")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.white.opacity(0.05))
                        .foregroundColor(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                        .cornerRadius(16)
                    }
                }
                .padding(30)
                .background(
                    RoundedRectangle(cornerRadius: 32)
                        .fill(Color.white.opacity(0.02))
                        .overlay(
                            RoundedRectangle(cornerRadius: 32)
                                .stroke(Color.white.opacity(0.05), lineWidth: 1)
                        )
                )
                .padding(.horizontal, 24)

                Spacer()
                
                // Navigation to Home
                NavigationLink(destination: Group {
                    if role == "inspector" {
                        PatientListView()
                    } else {
                        HomeView()
                    }
                }, isActive: $navigateToHome) {
                    EmptyView()
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct PremiumTextField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .foregroundColor(PulsaraTheme.textDim)
                .frame(width: 20)
            
            if isSecure {
                SecureField("", text: $text, prompt: Text(placeholder).foregroundColor(PulsaraTheme.textDim))
            } else {
                TextField("", text: $text, prompt: Text(placeholder).foregroundColor(PulsaraTheme.textDim))
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
        .foregroundColor(.white)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.05), lineWidth: 1))
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(role: "patient")
    }
}
