import SwiftUI

struct SignInView: View {
    let role: String
    @Environment(\.presentationMode) var presentationMode
    @State private var email = ""
    @State private var password = ""
    @State private var navigateToHome = false

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: "111827"), .black], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                // Back Button
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 20)

                VStack(spacing: 8) {
                    Text("Welcome Back")
                        .font(.title.bold())
                        .foregroundColor(.white)
                    
                    Text(role == "inspector" ? "Sign in to access your patients" : "Sign in to your journal")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 20)

                // Form
                VStack(spacing: 16) {
                    CustomTextField(label: "Email", text: $email, placeholder: "Enter your email")
                    CustomTextField(label: "Password", text: $password, placeholder: "Enter your password", isSecure: true)
                    
                    Button(action: {
                        // Handle real login
                    }) {
                        Text("Sign In")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(PulsaraTheme.primary)
                            .foregroundColor(.black)
                            .cornerRadius(12)
                    }
                    .padding(.top, 8)

                    // Dummy Login
                    Button(action: {
                        navigateToHome = true
                    }) {
                        Text("Login as \(role.capitalized) (Demo)")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white.opacity(0.05))
                            .foregroundColor(.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .cornerRadius(12)
                    }
                }
                .padding(32)
                .background(Color(hex: "111827"))
                .cornerRadius(24)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .padding(.horizontal)

                Spacer()
                
                // Navigation to Home
                NavigationLink(destination: Text("Home Screen for \(role)"), isActive: $navigateToHome) {
                    EmptyView()
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct CustomTextField: View {
    let label: String
    @Binding var text: String
    let placeholder: String
    var isSecure: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
            
            if isSecure {
                SecureField("", text: $text)
                    .padding()
                    .background(Color(hex: "111827"))
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
                    .foregroundColor(.white)
            } else {
                TextField("", text: $text)
                    .padding()
                    .background(Color(hex: "111827"))
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
                    .foregroundColor(.white)
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(role: "patient")
    }
}
