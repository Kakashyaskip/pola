import SwiftUI

struct RevealStep: View {
    @Bindable var vm: CreateEventViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Quand révéler\nvos photos ?")
                    .font(.polaTitle(34))
                    .foregroundStyle(.white)

                Text("Les photos sont masquées par défaut pendant l'événement.")
                    .font(.polaBody(15))
                    .foregroundStyle(Color(white: 0.45))
            }
            .padding(.horizontal, 20)

            Spacer().frame(height: 36)

            // Aperçu flou
            HStack(spacing: 12) {
                ForEach(0..<2) { _ in
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(white: 0.12))
                        .frame(maxWidth: .infinity)
                        .frame(height: 120)
                        .overlay {
                            if vm.revealMode != .during {
                                Text("🔒")
                                    .font(.system(size: 28))
                            }
                        }
                }
            }
            .padding(.horizontal, 20)

            Spacer().frame(height: 32)

            // Options
            VStack(spacing: 10) {
                ForEach(PolaEvent.RevealMode.allCases, id: \.self) { mode in
                    RevealOption(
                        mode: mode,
                        isSelected: vm.revealMode == mode
                    ) {
                        vm.revealMode = mode
                    }
                }
            }
            .padding(.horizontal, 20)

            Spacer()

            NextButton { vm.next() }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
        }
    }
}

private struct RevealOption: View {
    let mode: PolaEvent.RevealMode
    let isSelected: Bool
    let action: () -> Void

    var icon: String {
        switch mode {
        case .during: "eye"
        case .after: "clock"
        case .delay: "timer"
        }
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundStyle(isSelected ? .polaOrange : Color(white: 0.5))
                    .frame(width: 28)

                Text(mode.label)
                    .font(.polaMedium(15))
                    .foregroundStyle(.white)

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.polaOrange)
                }
            }
            .padding(16)
            .background(
                isSelected
                    ? Color.polaOrange.opacity(0.1)
                    : Color(white: 0.08)
            )
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? Color.polaOrange.opacity(0.4) : Color.clear, lineWidth: 1)
            )
        }
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}
