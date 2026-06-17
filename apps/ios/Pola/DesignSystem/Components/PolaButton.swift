import SwiftUI

struct PolaButton: View {
    enum Style {
        case primary    // fond blanc, texte noir
        case secondary  // fond gris sombre, texte blanc
        case orange     // fond orange, texte blanc
        case ghost      // bordure blanche, texte blanc
    }

    let title: String
    let icon: String?
    let style: Style
    let isLoading: Bool
    let action: () -> Void

    init(
        _ title: String,
        icon: String? = nil,
        style: Style = .primary,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.style = style
        self.isLoading = isLoading
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .tint(foregroundColor)
                        .scaleEffect(0.85)
                } else {
                    if let icon {
                        Image(systemName: icon)
                            .font(.system(size: 16, weight: .medium))
                    }
                    Text(title)
                        .font(.polaMedium(15))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(backgroundColor)
            .foregroundStyle(foregroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(borderColor, lineWidth: style == .ghost ? 1 : 0)
            )
        }
        .disabled(isLoading)
    }

    private var backgroundColor: Color {
        switch style {
        case .primary: .white
        case .secondary: Color(white: 0.15)
        case .orange: .polaOrange
        case .ghost: .clear
        }
    }

    private var foregroundColor: Color {
        switch style {
        case .primary: .polaBlack
        case .secondary: .white
        case .orange: .white
        case .ghost: .white
        }
    }

    private var borderColor: Color {
        style == .ghost ? Color(white: 0.3) : .clear
    }
}
