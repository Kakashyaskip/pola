import SwiftUI

struct GuestStep: View {
    @Bindable var vm: CreateEventViewModel
    let onDismiss: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Combien d'invités\npour votre film ?")
                    .font(.polaTitle(34))
                    .foregroundStyle(.white)

                Text("Choisissez le nombre maximum de participants.")
                    .font(.polaBody(15))
                    .foregroundStyle(Color(white: 0.45))
            }
            .padding(.horizontal, 20)

            Spacer().frame(height: 32)

            // Sélecteur invités
            VStack(alignment: .leading, spacing: 12) {
                SectionLabel("NOMBRE D'INVITÉS")

                HStack(spacing: 8) {
                    ForEach(vm.guestOptions, id: \.self) { count in
                        GuestCountChip(
                            count: count,
                            isSelected: vm.maxGuests == count
                        ) {
                            vm.maxGuests = count
                        }
                    }
                }

                Text("Jusqu'à \(vm.maxGuests) participants")
                    .font(.polaHeadline(24))
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 20)

            Spacer().frame(height: 28)

            // Sélecteur shots
            VStack(alignment: .leading, spacing: 12) {
                SectionLabel("PHOTOS PAR PERSONNE")

                HStack(spacing: 8) {
                    ForEach(vm.shotOptions, id: \.self) { count in
                        GuestCountChip(
                            count: count,
                            isSelected: vm.shotsPerPerson == count
                        ) {
                            vm.shotsPerPerson = count
                        }
                    }
                }
            }
            .padding(.horizontal, 20)

            Spacer().frame(height: 28)

            // Visibilité
            VStack(alignment: .leading, spacing: 12) {
                SectionLabel("VISIBILITÉ")

                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Tout le monde voit toutes les photos")
                            .font(.polaMedium(15))
                            .foregroundStyle(.white)
                        Text("Si désactivé, chaque invité voit uniquement les siennes.")
                            .font(.polaCaption(12))
                            .foregroundStyle(Color(white: 0.4))
                    }
                    Spacer()
                    Toggle("", isOn: $vm.isPublic)
                        .tint(.polaOrange)
                }
                .padding(16)
                .background(Color(white: 0.08))
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(.horizontal, 20)

            Spacer()

            // Bouton créer
            NextButton(label: "Créer l'événement", isLoading: vm.isLoading) {
                Task {
                    let success = await vm.create()
                    if success { onDismiss() }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
        }
    }
}

private struct SectionLabel: View {
    let text: String
    init(_ text: String) { self.text = text }

    var body: some View {
        Text(text)
            .font(.polaLabel(11))
            .tracking(1.5)
            .foregroundStyle(Color(white: 0.35))
    }
}

private struct GuestCountChip: View {
    let count: Int
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("\(count)")
                .font(.polaMedium(14))
                .foregroundStyle(isSelected ? .polaBlack : .white)
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .background(isSelected ? Color.white : Color(white: 0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}
