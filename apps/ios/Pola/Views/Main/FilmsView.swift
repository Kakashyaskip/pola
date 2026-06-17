import SwiftUI

struct FilmsView: View {
    @State private var vm = FilmsViewModel()

    var body: some View {
        ZStack {
            Color.polaBlack.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    // Header
                    HStack {
                        Text("pola")
                            .font(.polaWordmark(32))
                            .foregroundStyle(.white)
                            .kerning(-1)
                        Spacer()
                        Button {
                            // TODO: guest join
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "qrcode.viewfinder")
                                Text("Rejoindre")
                                    .font(.polaMedium(14))
                            }
                            .foregroundStyle(.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(Color(white: 0.15))
                            .clipShape(Capsule())
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)

                    // Section active
                    VStack(alignment: .leading, spacing: 12) {
                        SectionLabel("ACTIF")
                            .padding(.horizontal, 20)

                        if vm.activeEvents.isEmpty {
                            EmptyFilmsCard()
                                .padding(.horizontal, 20)
                        } else {
                            ForEach(vm.activeEvents) { event in
                                ActiveEventCard(event: event)
                                    .padding(.horizontal, 20)
                            }
                        }
                    }

                    // Section albums
                    VStack(alignment: .leading, spacing: 12) {
                        SectionLabel("ALBUMS")
                            .padding(.horizontal, 20)

                        if vm.pastAlbums.isEmpty {
                            Text("Vos événements passés apparaîtront ici.")
                                .font(.polaBody(14))
                                .foregroundStyle(Color(white: 0.35))
                                .padding(.horizontal, 20)
                        } else {
                            ForEach(vm.pastAlbums) { event in
                                AlbumRow(event: event)
                                    .padding(.horizontal, 20)
                            }
                        }
                    }

                    Spacer().frame(height: 100)
                }
            }
            .refreshable {
                await vm.load()
            }
        }
        .task {
            await vm.load()
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
            .foregroundStyle(Color(white: 0.4))
    }
}

private struct EmptyFilmsCard: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "film")
                .font(.system(size: 28))
                .foregroundStyle(Color(white: 0.3))

            Text("Aucun film actif")
                .font(.polaBody(15))
                .foregroundStyle(Color(white: 0.4))
        }
        .frame(maxWidth: .infinity)
        .frame(height: 120)
        .background(Color(white: 0.07))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

private struct ActiveEventCard: View {
    let event: PolaEvent

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(event.name)
                .font(.polaHeadline(20))
                .foregroundStyle(.white)

            HStack(spacing: 16) {
                StatChip(value: "\(event.photosCount)", label: "photos")
                StatChip(value: "\(event.guestsCount)", label: "invités")
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(white: 0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

private struct StatChip: View {
    let value: String
    let label: String

    var body: some View {
        HStack(spacing: 4) {
            Text(value).font(.polaMedium(14)).foregroundStyle(.white)
            Text(label).font(.polaCaption(12)).foregroundStyle(Color(white: 0.45))
        }
    }
}

private struct AlbumRow: View {
    let event: PolaEvent

    var body: some View {
        HStack(spacing: 14) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(white: 0.12))
                .frame(width: 64, height: 64)

            VStack(alignment: .leading, spacing: 4) {
                Text(event.name)
                    .font(.polaMedium(16))
                    .foregroundStyle(.white)
                Text(event.endDate.formatted(.dateTime.day().month().year()))
                    .font(.polaCaption(12))
                    .foregroundStyle(Color(white: 0.4))
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Color(white: 0.3))
        }
    }
}

#Preview {
    FilmsView()
}
