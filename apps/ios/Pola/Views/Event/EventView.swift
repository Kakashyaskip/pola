import SwiftUI

struct EventView: View {
    let event: PolaEvent
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.polaBlack.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    // Cover + header
                    ZStack(alignment: .bottom) {
                        // Image de fond
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [Color(white: 0.15), Color.polaBlack],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(height: 320)

                        // Overlay dégradé
                        LinearGradient(
                            colors: [.clear, Color.polaBlack.opacity(0.9)],
                            startPoint: .center,
                            endPoint: .bottom
                        )
                        .frame(height: 320)

                        VStack(spacing: 16) {
                            Text(event.name)
                                .font(.polaDisplay(40))
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.center)

                            HStack(spacing: 24) {
                                StatColumn(value: "\(event.photosCount)", label: "Moments")
                                StatColumn(
                                    value: event.endDate.formatted(.dateTime.day().month()),
                                    label: "Fin"
                                )
                                StatColumn(value: "\(event.guestsCount)", label: "Invités")
                            }

                            // Actions
                            HStack(spacing: 12) {
                                ActionButton(icon: "paperplane", label: "Partager") {
                                    // TODO: share QR / link
                                }
                                ActionButton(icon: "arrow.down.to.line", label: "Sauvegarder") {
                                    // TODO: download photos
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 24)
                    }

                    // Grille photos
                    if event.photosCount == 0 {
                        VStack(spacing: 12) {
                            Image(systemName: "camera")
                                .font(.system(size: 36))
                                .foregroundStyle(Color(white: 0.3))
                            Text("Aucune photo pour l'instant")
                                .font(.polaBody(15))
                                .foregroundStyle(Color(white: 0.35))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                    } else {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 2), count: 3), spacing: 2) {
                            ForEach(0..<event.photosCount, id: \.self) { _ in
                                Rectangle()
                                    .fill(Color(white: 0.12))
                                    .aspectRatio(1, contentMode: .fill)
                            }
                        }
                    }

                    Spacer().frame(height: 100)
                }
            }
            .ignoresSafeArea(edges: .top)

            // Back button
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(width: 40, height: 40)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    Spacer()

                    Button {
                        // TODO: event settings sheet
                    } label: {
                        Image(systemName: "gearshape")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(width: 40, height: 40)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 60)
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}

private struct StatColumn: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.polaMedium(18))
                .foregroundStyle(.white)
            Text(label)
                .font(.polaCaption(11))
                .foregroundStyle(Color(white: 0.45))
        }
    }
}

private struct ActionButton: View {
    let icon: String
    let label: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                Text(label)
                    .font(.polaMedium(14))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(Color(white: 0.15))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}
