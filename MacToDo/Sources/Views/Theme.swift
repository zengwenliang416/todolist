import SwiftUI

struct SketchTheme {
    // Paper Colors
    static let paperBackground = Color(red: 0.99, green: 0.98, blue: 0.96) // Warm Paper
    static let lineBlue = Color(red: 0.8, green: 0.85, blue: 0.9) // Notebook Line Blue
    static let marginPink = Color(red: 1.0, green: 0.8, blue: 0.8) // Notebook Margin Pink
    
    // Pencil Colors
    static let pencilGraphite = Color(red: 0.25, green: 0.25, blue: 0.28)
    static let pencilGray = Color(red: 0.5, green: 0.5, blue: 0.55)
    
    // Highlighter Colors
    static let highlighterYellow = Color(red: 1.0, green: 0.95, blue: 0.4, opacity: 0.6)
    static let highlighterPink = Color(red: 1.0, green: 0.6, blue: 0.8, opacity: 0.6)
    static let highlighterBlue = Color(red: 0.4, green: 0.8, blue: 1.0, opacity: 0.6)
    
    // Fonts
    // Using "Chalkboard SE" or "Bradley Hand" for that sketchy look
    static let fontName = "ChalkboardSE-Regular"
    static let fontBoldName = "ChalkboardSE-Bold"
    
    // Modifiers
    struct SketchFont: ViewModifier {
        var size: CGFloat
        var weight: Font.Weight
        
        func body(content: Content) -> some View {
            // Mapping weight roughly since custom fonts handle weight differently
            let name = (weight == .bold || weight == .heavy || weight == .black) ? SketchTheme.fontBoldName : SketchTheme.fontName
            return content.font(.custom(name, size: size))
        }
    }
    
    // A shaky border effect
    struct SketchyBorder: ViewModifier {
        func body(content: Content) -> some View {
            content
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(SketchTheme.pencilGraphite, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, dash: [50, 5], dashPhase: 2))
                        .opacity(0.7)
                )
        }
    }

    // iOS 26 Glass Texture (Glassmorphism + Sketch)
    struct GlassyEffect: ViewModifier {
        func body(content: Content) -> some View {
            content
                .background(.ultraThinMaterial)
                .background(Color.white.opacity(0.1))
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: 8)
                // Inner Glass Shine
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(LinearGradient(colors: [.white.opacity(0.6), .white.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
                        .padding(1)
                )
                // Sketchy Border on top of Glass
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(SketchTheme.pencilGraphite, style: StrokeStyle(lineWidth: 1.5, lineCap: .round, lineJoin: .round, dash: [30, 10], dashPhase: Double.random(in: 0...10)))
                        .opacity(0.6)
                )
        }
    }
}

extension View {
    func sketchFont(size: CGFloat = 16, weight: Font.Weight = .regular) -> some View {
        self.modifier(SketchTheme.SketchFont(size: size, weight: weight))
    }
    
    func sketchyBorder() -> some View {
        self.modifier(SketchTheme.SketchyBorder())
    }
    
    func glassySketchStyle() -> some View {
        self.modifier(SketchTheme.GlassyEffect())
    }
    
    func notebookStyle() -> some View {
        self
            .background(SketchTheme.paperBackground)
    }
}
