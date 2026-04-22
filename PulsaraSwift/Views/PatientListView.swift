import SwiftUI

struct PatientListView: View {
    @State private var searchQuery = ""
    
    let patients = [
        Patient(name: "Aarav Patel", status: "Stable", lastCheckIn: "2 hours ago", mood: "good"),
        Patient(name: "Diya Sharma", status: "Needs Attention", lastCheckIn: "1 day ago", mood: "bad"),
        Patient(name: "Vihaan Singh", status: "Improving", lastCheckIn: "5 hours ago", mood: "meh"),
        Patient(name: "Ananya Gupta", status: "Stable", lastCheckIn: "10 mins ago", mood: "rad"),
        Patient(name: "Ishaan Kumar", status: "Critical", lastCheckIn: "30 mins ago", mood: "awful")
    ]
    
    var body: some View {
        ZStack {
            PulsaraTheme.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Hello, Dr. Wellness")
                            .font(.title.bold())
                            .foregroundColor(.white)
                        Text("MENTAL WELLNESS INSPECTOR")
                            .font(.caption.bold())
                            .foregroundColor(PulsaraTheme.primary)
                            .tracking(1)
                    }
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(PulsaraTheme.error)
                            .padding(10)
                            .background(PulsaraTheme.surface)
                            .cornerRadius(12)
                    }
                }
                .padding()
                .padding(.top, 20)

                // Search
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(PulsaraTheme.textSecondary)
                    TextField("Search patients...", text: $searchQuery)
                        .foregroundColor(.white)
                }
                .padding()
                .background(PulsaraTheme.surface)
                .cornerRadius(16)
                .padding(.horizontal)
                .padding(.bottom, 20)

                // List
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("ASSIGNED PATIENTS (\(patients.count))")
                            .font(.caption.bold())
                            .foregroundColor(PulsaraTheme.textSecondary)
                            .padding(.horizontal)
                        
                        ForEach(patients) { patient in
                            PatientCard(patient: patient)
                        }
                    }
                    .padding(.bottom, 100)
                }
            }
        }
    }
}

struct PatientCard: View {
    let patient: Patient
    
    var body: some View {
        HStack(spacing: 16) {
            // Avatar
            ZStack {
                Circle()
                    .stroke(getStatusColor(patient.mood), lineWidth: 2)
                    .frame(width: 56, height: 56)
                
                Text(String(patient.name.prefix(1)))
                    .font(.title3.bold())
                    .foregroundColor(.white)
            }
            .background(PulsaraTheme.surfaceLight.clipShape(Circle()))

            VStack(alignment: .leading, spacing: 4) {
                Text(patient.name)
                    .font(.headline)
                    .foregroundColor(.white)
                
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.caption)
                    Text(patient.lastCheckIn)
                        .font(.caption)
                }
                .foregroundColor(PulsaraTheme.textSecondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text(patient.status)
                    .font(.caption.bold())
                    .foregroundColor(getStatusColor(patient.mood))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(PulsaraTheme.surfaceLight)
                    .cornerRadius(8)
            }
            
            Image(systemName: "chevron.right")
                .foregroundColor(PulsaraTheme.textDim)
        }
        .padding()
        .background(PulsaraTheme.surface)
        .cornerRadius(20)
        .padding(.horizontal)
    }
    
    func getStatusColor(_ mood: String) -> Color {
        switch mood {
        case "rad": return .green
        case "good": return .green.opacity(0.8)
        case "meh": return .yellow
        case "bad": return .orange
        case "awful": return .red
        default: return .gray
        }
    }
}

struct Patient: Identifiable {
    let id = UUID()
    let name: String
    let status: String
    let lastCheckIn: String
    let mood: String
}

struct PatientListView_Previews: PreviewProvider {
    static var previews: some View {
        PatientListView()
    }
}
