import SwiftUI

enum AppTheme {
    // MARK: - Colors

    static let background = Color(NSColor.windowBackgroundColor)
    static let secondaryBackground = Color(NSColor.controlBackgroundColor)
    static let tertiaryBackground = Color(NSColor.alternatingContentBackgroundColors[1])

    static let primaryText = Color.primary
    static let secondaryText = Color.secondary

    static let accent = Color.accentColor

    // Custom Palette
    enum Palette {
        static let blue = Color.blue
        static let purple = Color.purple
        static let pink = Color.pink
        static let orange = Color.orange
        static let green = Color.green
        static let gray = Color.gray
    }

    // MARK: - Typography

    struct AppFont: ViewModifier {
        var size: CGFloat
        var weight: Font.Weight
        var design: Font.Design

        func body(content: Content) -> some View {
            content.font(.system(size: size, weight: weight, design: design))
        }
    }

    // MARK: - Styles
    struct CardStyle: ViewModifier {
        func body(content: Content) -> some View {
            content
                .background(Color(NSColor.controlBackgroundColor))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }

    struct GlassyCardStyle: ViewModifier {
        func body(content: Content) -> some View {
            content
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        }
    }
}

extension View {
    func appFont(size: CGFloat = 16, weight: Font.Weight = .regular, design: Font.Design = .rounded) -> some View {
        modifier(AppTheme.AppFont(size: size, weight: weight, design: design))
    }

    func cardStyle() -> some View {
        modifier(AppTheme.CardStyle())
    }

    func glassyCardStyle() -> some View {
        modifier(AppTheme.GlassyCardStyle())
    }
}
