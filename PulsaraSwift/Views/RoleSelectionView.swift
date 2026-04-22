import SwiftUI

struct RoleSelectionView: View {
    var body: some View {
        NavigationView {
            ZStack {
                // Premium Background
                PulsaraTheme.background.ignoresSafeArea()
                
                // Decorative elements
                Circle()
                    .fill(PulsaraTheme.primary.opacity(0.1))
                    .frame(width: 400, height: 400)
                    .blur(radius: 80)
                    .offset(x: -150, y: -200)
                
                Circle()
                    .fill(PulsaraTheme.accent.opacity(0.05))
                    .frame(width: 300, height: 300)
                    .blur(radius: 60)
                    .offset(x: 150, y: 300)

                VStack(spacing: 40) {
                    // Logo/Header Area
                    VStack(spacing: 16) {
                        Image(systemName: "waveform.path.ecg")
                            .font(.system(size: 60))
                            .foregroundStyle(PulsaraTheme.goldGradient)
                            .shadow(color: PulsaraTheme.primary.opacity(0.3), radius: 15)
                        
                        Text("PULSARA")
                            .font(.system(size: 32, weight: .black, design: .rounded))
                            .tracking(4)
                            .foregroundColor(.white)
                        
                        Text("Elevate Your Mental Wellness")
                            .font(.subheadline)
                            .foregroundColor(PulsaraTheme.textSecondary)
                    }
                    .padding(.top, 40)

                    Text("CHOOSE YOUR ROLE")
                        .font(.caption.bold())
                        .foregroundColor(PulsaraTheme.textDim)
                        .tracking(2)

                    VStack(spacing: 20) {
                        RoleCard(
                            icon: "person.fill",
                            title: "I am a Patient",
                            description: "Track your journey, log your thoughts, and find inner peace.",
                            role: "patient"
                        )
                        
                        RoleCard(
                            icon: "shield.fill",
                            title: "I am an Inspector",
                            description: "Monitor patient wellness and provide professional insights.",
                            role: "inspector"
                        )
                    }
                    .padding(.horizontal, 24)

                    Spacer()
                    
                    Text("By continuing, you agree to our Terms & Privacy Policy")
                        .font(.caption2)
                        .foregroundColor(PulsaraTheme.textDim)
                        .padding(.bottom, 20)
                }
            }
        }
    }
}

struct RoleCard: View {
    let icon: String
    let title: String
    let description: String
    let role: String
    
    var body: some View {
        NavigationLink(destination: SignInView(role: role)) {
            HStack(spacing: 20) {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(PulsaraTheme.surfaceLight)
                        .frame(width: 56, height: 56)
                    
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundStyle(PulsaraTheme.goldGradient)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(description)
                        .font(.caption)
                        .foregroundColor(PulsaraTheme.textSecondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption.bold())
                    .foregroundColor(PulsaraTheme.textDim)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.white.opacity(0.03))
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                    )
            )
            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct RoleSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        RoleSelectionView()
    }
}
