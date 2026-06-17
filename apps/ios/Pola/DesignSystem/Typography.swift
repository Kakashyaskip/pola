import SwiftUI

extension Font {
    // Sérif — titres principaux
    static func polaDisplay(_ size: CGFloat = 48) -> Font {
        .system(size: size, weight: .semibold, design: .serif)
    }

    static func polaTitle(_ size: CGFloat = 32) -> Font {
        .system(size: size, weight: .semibold, design: .serif)
    }

    static func polaHeadline(_ size: CGFloat = 22) -> Font {
        .system(size: size, weight: .semibold, design: .serif)
    }

    // Sans-serif — corps et UI
    static func polaBody(_ size: CGFloat = 16) -> Font {
        .system(size: size, weight: .regular, design: .default)
    }

    static func polaMedium(_ size: CGFloat = 15) -> Font {
        .system(size: size, weight: .medium, design: .default)
    }

    static func polaCaption(_ size: CGFloat = 12) -> Font {
        .system(size: size, weight: .medium, design: .default)
    }

    // Labels uppercase tracké
    static func polaLabel(_ size: CGFloat = 11) -> Font {
        .system(size: size, weight: .semibold, design: .default)
    }

    // Wordmark grotesque
    static func polaWordmark(_ size: CGFloat = 64) -> Font {
        .system(size: size, weight: .black, design: .default)
    }
}
