import SwiftUI

extension Font {
    static func polaWordmark(size: CGFloat = 64) -> Font {
        .system(size: size, weight: .black, design: .default)
    }

    static func polaTitle() -> Font {
        .system(size: 28, weight: .bold, design: .default)
    }

    static func polaBody() -> Font {
        .system(size: 16, weight: .regular, design: .default)
    }

    static func polaCaption() -> Font {
        .system(size: 12, weight: .medium, design: .default)
    }
}
