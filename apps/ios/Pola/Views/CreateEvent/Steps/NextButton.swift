import SwiftUI

struct NextButton: View {
    let label: String
    let disabled: Bool
    let isLoading: Bool
    let action: () -> Void

    init(label: String = "Suivant", disabled: Bool = false, isLoading: Bool = false, action: @escaping () -> Void) {
        self.label = label
        self.disabled = disabled
        self.isLoading = isLoading
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView().tint(.polaBlack).scaleEffect(0.85)
                } else {
                    Text(label)
                        .font(.polaMedium(15))
                    Image(systemName: "arrow.right")
                        .font(.system(size: 13, weight: .semibold))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(disabled ? Color(white: 0.2) : Color.white)
            .foregroundStyle(disabled ? Color(white: 0.4) : Color.polaBlack)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .disabled(disabled || isLoading)
        .animation(.easeInOut(duration: 0.2), value: disabled)
    }
}
