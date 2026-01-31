import SwiftUI

/// A reusable glass/blur background effect for the widget
/// Provides a modern macOS translucent appearance with subtle blur
struct GlassBackground: View {
    /// Corner radius for the background shape
    var cornerRadius: CGFloat = 16

    /// Opacity of the glass effect
    var opacity: Double = 0.1

    /// Border opacity for the glass edge
    var borderOpacity: Double = 0.2

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(.ultraThinMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(opacity * 1.5),
                                Color.white.opacity(opacity * 0.5)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(borderOpacity),
                                Color.white.opacity(borderOpacity * 0.5)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.5
                    )
            )
    }
}

/// View modifier for applying glass background to any view
struct GlassBackgroundModifier: ViewModifier {
    var cornerRadius: CGFloat
    var opacity: Double
    var borderOpacity: Double

    func body(content: Content) -> some View {
        content
            .background(
                GlassBackground(
                    cornerRadius: cornerRadius,
                    opacity: opacity,
                    borderOpacity: borderOpacity
                )
            )
    }
}

extension View {
    /// Apply a glass background effect to this view
    /// - Parameters:
    ///   - cornerRadius: Corner radius for the glass shape (default: 16)
    ///   - opacity: Opacity of the glass fill (default: 0.1)
    ///   - borderOpacity: Opacity of the glass border (default: 0.2)
    func glassBackground(
        cornerRadius: CGFloat = 16,
        opacity: Double = 0.1,
        borderOpacity: Double = 0.2
    ) -> some View {
        modifier(
            GlassBackgroundModifier(
                cornerRadius: cornerRadius,
                opacity: opacity,
                borderOpacity: borderOpacity
            )
        )
    }
}

#Preview {
    VStack(spacing: 20) {
        Text("Glass Background")
            .font(.headline)
            .padding()
            .glassBackground()

        GlassBackground(cornerRadius: 12)
            .frame(width: 200, height: 100)
    }
    .padding()
    .background(Color.gray.opacity(0.3))
}
