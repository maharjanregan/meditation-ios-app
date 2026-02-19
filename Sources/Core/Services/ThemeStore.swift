import SwiftUI

struct AppTheme: Hashable {
    let name: String
    let background: Color
    let surface: Color
    let textPrimary: Color
    let textSecondary: Color
    let accent: Color

    static let calmSand = AppTheme(
        name: "Calm Sand",
        background: Color(red: 0.98, green: 0.97, blue: 0.95),
        surface: Color.white.opacity(0.8),
        textPrimary: Color(red: 0.12, green: 0.12, blue: 0.14),
        textSecondary: Color(red: 0.35, green: 0.35, blue: 0.40),
        accent: Color(red: 0.20, green: 0.36, blue: 0.42)
    )

    static let highContrast = AppTheme(
        name: "High Contrast",
        background: Color.black,
        surface: Color(red: 0.10, green: 0.10, blue: 0.12),
        textPrimary: Color.white,
        textSecondary: Color.white.opacity(0.85),
        accent: Color(red: 0.34, green: 0.78, blue: 0.98)
    )
}

@MainActor
final class ThemeStore: ObservableObject {
    static let shared = ThemeStore()

    @Published var theme: AppTheme = .calmSand
    @AppStorage("prefersHighContrast") var prefersHighContrast: Bool = false {
        didSet { theme = prefersHighContrast ? .highContrast : .calmSand }
    }

    private init() {
        theme = prefersHighContrast ? .highContrast : .calmSand
    }
}
