import SwiftUI

// Mirrors ../../DESIGN_DNA.md: Headspace/Calm-inspired, chat-first, private by default.
enum BridgePalette {
    static let ink = Color(red: 0.20, green: 0.17, blue: 0.14)
    static let muted = Color(red: 0.44, green: 0.38, blue: 0.34)
    static let sage = Color(red: 0.33, green: 0.47, blue: 0.40)
    static let deepSage = Color(red: 0.21, green: 0.34, blue: 0.27)
    static let sageSoft = Color(red: 0.86, green: 0.91, blue: 0.86)
    static let cream = Color(red: 1.00, green: 0.98, blue: 0.94)
    static let peach = Color(red: 0.95, green: 0.78, blue: 0.65)
    static let lavender = Color(red: 0.85, green: 0.82, blue: 0.94)
    static let lavenderDeep = Color(red: 0.40, green: 0.33, blue: 0.56)
}

struct BridgeBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                BridgePalette.deepSage,
                BridgePalette.sage,
                BridgePalette.lavender,
                BridgePalette.cream
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .overlay(
            Circle()
                .fill(BridgePalette.peach.opacity(0.34))
                .blur(radius: 70)
                .offset(x: 120, y: -260)
        )
        .ignoresSafeArea()
    }
}

struct SoftSurface<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(18)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(.white.opacity(0.35), lineWidth: 1)
            )
    }
}

struct SourceLabel: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .font(.caption.weight(.bold))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(color.opacity(0.18), in: Capsule())
            .foregroundStyle(color)
    }
}
