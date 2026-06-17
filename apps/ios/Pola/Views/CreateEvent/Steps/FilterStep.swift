import SwiftUI

struct FilterStep: View {
    @Bindable var vm: CreateEventViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Quel rendu\npour votre film ?")
                    .font(.polaTitle(34))
                    .foregroundStyle(.white)

                Text("Le filtre s'applique à toutes les photos de l'événement.")
                    .font(.polaBody(15))
                    .foregroundStyle(Color(white: 0.45))
            }
            .padding(.horizontal, 20)

            Spacer().frame(height: 32)

            // Aperçu filtre
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(white: 0.1))
                .frame(maxWidth: .infinity)
                .frame(height: 180)
                .overlay {
                    Text(filterEmoji)
                        .font(.system(size: 64))
                }
                .padding(.horizontal, 20)
                .animation(.easeInOut(duration: 0.2), value: vm.selectedFilter)

            Spacer().frame(height: 24)

            // Sélecteur
            HStack(spacing: 12) {
                ForEach(PolaEvent.FilmFilter.allCases, id: \.self) { filter in
                    FilterChip(
                        filter: filter,
                        isSelected: vm.selectedFilter == filter
                    ) {
                        vm.selectedFilter = filter
                    }
                }
            }
            .padding(.horizontal, 20)

            Spacer().frame(height: 16)

            // Description
            Text(vm.selectedFilter.description)
                .font(.polaBody(14))
                .foregroundStyle(Color(white: 0.5))
                .padding(.horizontal, 20)
                .animation(.easeInOut(duration: 0.2), value: vm.selectedFilter)

            Spacer()

            NextButton { vm.next() }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
        }
    }

    private var filterEmoji: String {
        switch vm.selectedFilter {
        case .original: "🏔️"
        case .grain: "📷"
        case .fade: "🌅"
        }
    }
}

private struct FilterChip: View {
    let filter: PolaEvent.FilmFilter
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? Color.polaOrange.opacity(0.15) : Color(white: 0.1))
                    .frame(height: 56)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(isSelected ? Color.polaOrange : Color.clear, lineWidth: 1.5)
                    )

                Text(filter.label)
                    .font(.polaCaption(12))
                    .foregroundStyle(isSelected ? .polaOrange : Color(white: 0.5))
            }
            .frame(maxWidth: .infinity)
        }
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}
