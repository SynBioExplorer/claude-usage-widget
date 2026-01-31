import SwiftUI

/// A progress bar with liquid glass effect for the Claude Usage Widget
/// Features translucent background, smooth corners, and customizable fill color
struct GlassProgressBar: View {
    /// Progress value from 0.0 to 1.0
    let progress: Double

    /// Color for the filled portion of the progress bar
    var fillColor: Color = Color.blue

    /// Height of the progress bar
    var height: CGFloat = 8

    /// Corner radius for the progress bar (defaults to half the height for pill shape)
    var cornerRadius: CGFloat? = nil

    /// Computed corner radius - uses half height if not specified
    private var effectiveCornerRadius: CGFloat {
        cornerRadius ?? height / 2
    }

    /// Clamped progress value between 0 and 1
    private var clampedProgress: Double {
        min(max(progress, 0), 1)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background track with glass effect
                RoundedRectangle(cornerRadius: effectiveCornerRadius)
                    .fill(Color.gray.opacity(0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: effectiveCornerRadius)
                            .fill(.ultraThinMaterial.opacity(0.5))
                    )

                // Filled portion with gradient
                if clampedProgress > 0 {
                    RoundedRectangle(cornerRadius: effectiveCornerRadius)
                        .fill(
                            LinearGradient(
                                colors: [
                                    fillColor.opacity(0.9),
                                    fillColor
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * clampedProgress)
                        .overlay(
                            // Subtle shine effect on the fill
                            RoundedRectangle(cornerRadius: effectiveCornerRadius)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.white.opacity(0.3),
                                            Color.white.opacity(0.0)
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .frame(width: geometry.size.width * clampedProgress)
                        )
                }
            }
        }
        .frame(height: height)
    }
}

/// Convenience initializer using ProgressBarConfiguration from contracts
extension GlassProgressBar {
    /// Initialize from a ProgressBarConfiguration
    /// - Parameter configuration: The configuration object defining progress, color, and height
    init(configuration: ProgressBarConfiguration) {
        self.progress = configuration.progress
        self.fillColor = configuration.fillColor
        self.height = configuration.height
        self.cornerRadius = nil
    }
}
