import SwiftUI
import PhotosUI

struct CoverStep: View {
    @Bindable var vm: CreateEventViewModel
    @State private var photosPickerItem: PhotosPickerItem?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Créez la carte\nd'invitation.")
                    .font(.polaTitle(34))
                    .foregroundStyle(.white)

                Text("C'est la première chose que verront vos invités.")
                    .font(.polaBody(15))
                    .foregroundStyle(Color(white: 0.45))
            }
            .padding(.horizontal, 20)

            Spacer().frame(height: 32)

            // Aperçu de la carte
            ZStack(alignment: .bottom) {
                Group {
                    if let data = vm.coverImageData, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                    } else {
                        Rectangle()
                            .fill(Color(white: 0.1))
                            .overlay {
                                Image(systemName: "photo")
                                    .font(.system(size: 36))
                                    .foregroundStyle(Color(white: 0.3))
                            }
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 260)
                .clipShape(RoundedRectangle(cornerRadius: 20))

                // Overlay info
                VStack(alignment: .leading, spacing: 6) {
                    Text(vm.name.isEmpty ? "Nom de l'événement" : vm.name)
                        .font(.polaHeadline(20))
                        .foregroundStyle(.white)

                    HStack(spacing: 12) {
                        Label(vm.endDate.formatted(.dateTime.day().month()), systemImage: "calendar")
                        Label("\(vm.shotsPerPerson) photos", systemImage: "camera")
                    }
                    .font(.polaCaption(12))
                    .foregroundStyle(Color(white: 0.7))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(8)
            }
            .padding(.horizontal, 20)

            Spacer().frame(height: 20)

            // Actions
            HStack(spacing: 12) {
                PhotosPicker(selection: $photosPickerItem, matching: .images) {
                    HStack(spacing: 8) {
                        Image(systemName: "photo")
                        Text("Choisir une photo")
                            .font(.polaMedium(14))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color(white: 0.1))
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding(.horizontal, 20)

            Spacer()

            NextButton { vm.next() }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
        }
        .onChange(of: photosPickerItem) { _, newItem in
            Task {
                vm.coverImageData = try? await newItem?.loadTransferable(type: Data.self)
            }
        }
    }
}
