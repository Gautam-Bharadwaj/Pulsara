import SwiftUI

struct RoleSelectionView: View {
    @State private var navigateToSignIn = false
    @State private var selectedRole: String = ""

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(colors: [PulsaraTheme.background, Color(hex: "1a1a2e")], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                VStack(spacing: 40) {
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: "fitness.timer")
                            .font(.system(size: 60))
                            .foregroundColor(PulsaraTheme.primary)
                        
                        Text("Pulsara")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(PulsaraTheme.text)
                        
                        Text("Choose your role to continue")
                            .font(.system(size: 16))
                            .foregroundColor(PulsaraTheme.textSecondary)
                    }
                    .padding(.top, 40)

                    // Cards
                    VStack(spacing: 20) {
                        RoleCard(
                            title: "Patient",
                            description: "I want to track my mental wellness and journal my thoughts.",
                            iconName: "person.fill",
                            color: PulsaraTheme.primary
                        ) {
                            selectedRole = "patient"
                            navigateToSignIn = true
                        }

                        RoleCard(
                            title: "Wellness Inspector",
                            description: "I am a trainer or doctor monitoring my patients.",
                            iconName: "cross.case.fill",
                            color: Color.green
                        ) {
                            selectedRole = "inspector"
                            navigateToSignIn = true
                        }
                    }
                    .padding(.horizontal, 20)

                    Spacer()
                }
                
                // Navigation Link (Hidden)
                NavigationLink(destination: SignInView(role: selectedRole), isActive: $navigateToSignIn) {
                    EmptyView()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct RoleCard: View {
    let title: String
    let description: String
    let iconName: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.1))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: iconName)
                        .font(.system(size: 24))
                        .foregroundColor(color)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(PulsaraTheme.text)
                    
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(PulsaraTheme.textSecondary)
                        .multilineTextAlignment(.leading)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(PulsaraTheme.textDim)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(PulsaraTheme.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(PulsaraTheme.surfaceLight, lineWidth: 1)
                    )
            )
        }
    }
}

struct RoleSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        RoleSelectionView()
    }
}
