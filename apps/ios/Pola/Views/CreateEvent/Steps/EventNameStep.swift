import SwiftUI

struct EventNameStep: View {
    @Bindable var vm: CreateEventViewModel
    @FocusState private var focused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Quel est le nom\nde votre événement ?")
                    .font(.polaTitle(34))
                    .foregroundStyle(.white)

                Text("Ce titre sera visible par tous vos invités.")
                    .font(.polaBody(15))
                    .foregroundStyle(Color(white: 0.45))
            }
            .padding(.horizontal, 20)

            Spacer().frame(height: 36)

            // Champ texte
            HStack(spacing: 10) {
                Image(systemName: "pencil")
                    .foregroundStyle(Color(white: 0.4))
                TextField("Nom de l'événement", text: $vm.name)
                    .font(.polaMedium(16))
                    .foregroundStyle(.white)
                    .focused($focused)
                    .submitLabel(.next)
                    .onSubmit { if vm.canProceed { vm.next() } }
            }
            .padding(16)
            .background(Color(white: 0.1))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .padding(.horizontal, 20)

            Spacer().frame(height: 28)

            // Suggestions
            VStack(alignment: .leading, spacing: 10) {
                Text("SUGGESTIONS")
                    .font(.polaLabel(11))
                    .tracking(1.5)
                    .foregroundStyle(Color(white: 0.35))

                FlowLayout(spacing: 10) {
                    ForEach(vm.nameSuggestions, id: \.self) { suggestion in
                        Button {
                            vm.name = suggestion
                        } label: {
                            Text(suggestion)
                                .font(.polaMedium(14))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(
                                    vm.name == suggestion
                                        ? Color.polaOrange.opacity(0.2)
                                        : Color(white: 0.1)
                                )
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule().stroke(
                                        vm.name == suggestion ? Color.polaOrange : Color.clear,
                                        lineWidth: 1
                                    )
                                )
                        }
                    }
                }
            }
            .padding(.horizontal, 20)

            Spacer()

            // Bouton suivant
            NextButton(disabled: !vm.canProceed, isLoading: false) {
                focused = false
                vm.next()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
        }
        .onAppear { focused = true }
    }
}

// Layout fluide pour les suggestions
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? 0
        var height: CGFloat = 0
        var x: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > width, x > 0 {
                height += rowHeight + spacing
                x = 0
                rowHeight = 0
            }
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
        height += rowHeight
        return CGSize(width: width, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX
        var y = bounds.minY
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX, x > bounds.minX {
                y += rowHeight + spacing
                x = bounds.minX
                rowHeight = 0
            }
            subview.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}
