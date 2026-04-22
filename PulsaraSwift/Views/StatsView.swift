import SwiftUI

struct StatsView: View {
    var body: some View {
        ZStack {
            PulsaraTheme.background.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    Text("Your Progress")
                        .font(.title.bold())
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.top, 20)

                    // Mood Summary Card
                    VStack(alignment: .leading, spacing: 20) {
                        Text("MOOD SUMMARY (LAST 7 DAYS)")
                            .font(.caption.bold())
                            .foregroundColor(PulsaraTheme.primary)
                        
                        HStack(alignment: .bottom, spacing: 12) {
                            ForEach(0..<7) { i in
                                VStack(spacing: 8) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(PulsaraTheme.primary.opacity(Double.random(in: 0.3...1.0)))
                                        .frame(width: 30, height: CGFloat.random(in: 40...120))
                                    Text(["M", "T", "W", "T", "F", "S", "S"][i])
                                        .font(.caption2)
                                        .foregroundColor(PulsaraTheme.textSecondary)
                                }
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(PulsaraTheme.surface)
                    .cornerRadius(20)
                    .padding(.horizontal)

                    // Top Tags
                    VStack(alignment: .leading, spacing: 16) {
                        Text("MOST USED TAGS")
                            .font(.caption.bold())
                            .foregroundColor(PulsaraTheme.primary)
                        
                        FlowLayout(spacing: 10) {
                            TagView(name: "Work", count: 12)
                            TagView(name: "Happy", count: 8)
                            TagView(name: "Tired", count: 5)
                            TagView(name: "Excited", count: 4)
                            TagView(name: "Stress", count: 3)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
        }
    }
}

struct TagView: View {
    let name: String
    let count: Int
    
    var body: some View {
        HStack(spacing: 6) {
            Text(name)
                .foregroundColor(.white)
            Text("\(count)")
                .foregroundColor(PulsaraTheme.primary)
                .font(.caption.bold())
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(PulsaraTheme.surface)
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray.opacity(0.1)))
    }
}

// Simple FlowLayout helper
struct FlowLayout: View {
    let spacing: CGFloat
    let content: [AnyView]
    
    init<Views>(spacing: CGFloat, @ViewBuilder content: () -> Views) where Views: View {
        self.spacing = spacing
        self.content = [AnyView(content())] // Simplified for demo
    }
    
    var body: some View {
        HStack {
            ForEach(0..<content.count, id: \.self) { i in
                content[i]
            }
        }
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}
