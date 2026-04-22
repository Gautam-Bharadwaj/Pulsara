import SwiftUI
import UIKit

struct PulsaraTheme {
    static let background = Color(hex: "081211")
    static let backgroundElevated = Color(hex: "0E1B19")
    static let surface = Color(hex: "132421")
    static let surfaceLight = Color(hex: "1B302C")
    static let surfaceSecondary = Color(hex: "203A35")

    static let primary = Color(hex: "8FD6C7")
    static let primaryLight = Color(hex: "BFE9DF")
    static let accent = Color(hex: "D8C7A3")
    static let success = Color(hex: "8DCC9F")
    static let warning = Color(hex: "E2BD78")
    static let critical = Color(hex: "D77F7A")
    static let error = Color(hex: "D77F7A")

    static let text = Color(hex: "F4F7F5")
    static let textPrimary = Color(hex: "F4F7F5")
    static let textSecondary = Color(hex: "B8C7C2")
    static let textTertiary = Color(hex: "7F9690")
    static let textDim = Color(hex: "667C76")

    static let mainGradient = LinearGradient(
        colors: [backgroundElevated, background],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let brandGradient = LinearGradient(
        colors: [primaryLight, primary, accent],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let goldGradient = brandGradient
}

struct Haptics {
    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }

    static func notify(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        UINotificationFeedbackGenerator().notificationOccurred(type)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 255, 255, 255)
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
