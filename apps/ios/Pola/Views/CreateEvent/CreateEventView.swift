import SwiftUI

struct CreateEventView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var vm = CreateEventViewModel()

    var body: some View {
        ZStack {
            Color.polaBlack.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header barre de progression
                VStack(spacing: 16) {
                    HStack {
                        Button {
                            if vm.step == 1 { dismiss() } else { vm.previous() }
                        } label: {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.white)
                                .frame(width: 40, height: 40)
                                .background(Color(white: 0.12))
                                .clipShape(Circle())
                        }
                        Spacer()
                    }

                    // Indicateur étapes
                    HStack(spacing: 6) {
                        ForEach(1...vm.totalSteps, id: \.self) { i in
                            Capsule()
                                .fill(i <= vm.step ? Color.polaOrange : Color(white: 0.2))
                                .frame(height: 3)
                                .animation(.spring(duration: 0.3), value: vm.step)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 24)

                // Contenu de l'étape
                Group {
                    switch vm.step {
                    case 1: EventNameStep(vm: vm)
                    case 2: EventDateStep(vm: vm)
                    case 3: RevealStep(vm: vm)
                    case 4: FilterStep(vm: vm)
                    case 5: CoverStep(vm: vm)
                    case 6: GuestStep(vm: vm, onDismiss: { dismiss() })
                    default: EmptyView()
                    }
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
                .animation(.spring(duration: 0.35), value: vm.step)
            }
        }
    }
}

#Preview {
    CreateEventView()
}
