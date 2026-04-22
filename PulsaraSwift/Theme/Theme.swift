import SwiftUI

struct PulsaraTheme {
    static let background = Color(hex: "050505")
    static let surface = Color(hex: "121212")
    static let surfaceLight = Color(hex: "1C1C1E")
    static let primary = Color(hex: "FFD600")
    static let primaryLight = Color(hex: "FFE082")
    static let accent = Color(hex: "FFAB00")
    static let text = Color.white
    static let textSecondary = Color(hex: "A1A1AA")
    static let textDim = Color(hex: "52525B")
    static let error = Color(hex: "EF4444")
    
    static let mainGradient = LinearGradient(
        colors: [Color(hex: "18181B"), Color(hex: "09090B")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let goldGradient = LinearGradient(
        colors: [Color(hex: "FFD600"), Color(hex: "FFAB00")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
