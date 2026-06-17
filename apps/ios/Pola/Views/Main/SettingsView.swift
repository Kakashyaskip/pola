import SwiftUI

struct SettingsView: View {
    @Environment(AuthViewModel.self) private var auth

    var body: some View {
        ZStack {
            Color.polaBlack.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    Text("Réglages")
                        .font(.polaTitle(32))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20)
                        .padding(.top, 16)

                    // Profil
                    VStack(alignment: .leading, spacing: 12) {
                        SectionHeader("INFOS")

                        HStack(spacing: 14) {
                            Circle()
                                .fill(Color(white: 0.2))
                                .frame(width: 48, height: 48)
                                .overlay {
                                    Text("T")
                                        .font(.polaMedium(18))
                                        .foregroundStyle(.white)
                                }

                            Text("Teddy Saury")
                                .font(.polaMedium(16))
                                .foregroundStyle(.white)

                            Spacer()

                            Image(systemName: "pencil")
                                .foregroundStyle(Color(white: 0.4))
                        }
                        .padding(16)
                        .background(Color(white: 0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .padding(.horizontal, 20)

                    // Support
                    VStack(alignment: .leading, spacing: 12) {
                        SectionHeader("SUPPORT")

                        SettingsRow(icon: "envelope", label: "Contacter le support") {}
                        SettingsRow(icon: "star", label: "Noter Pola") {}
                    }
                    .padding(.horizontal, 20)

                    // Compte
                    VStack(alignment: .leading, spacing: 12) {
                        SectionHeader("COMPTE")

                        SettingsRow(icon: "rectangle.portrait.and.arrow.right", label: "Se déconnecter", tint: .polaOrange) {
                            auth.signOut()
                        }

                        SettingsRow(icon: "trash", label: "Supprimer le compte", tint: .red) {
                            // TODO: confirmation + API delete
                        }
                    }
                    .padding(.horizontal, 20)

                    Spacer().frame(height: 100)
                }
            }
        }
    }
}

private struct SectionHeader: View {
    let text: String
    init(_ text: String) { self.text = text }

    var body: some View {
        Text(text)
            .font(.polaLabel(11))
            .tracking(1.5)
            .foregroundStyle(Color(white: 0.4))
    }
}

private struct SettingsRow: View {
    let icon: String
    let label: String
    var tint: Color = .white
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundStyle(tint)
                    .frame(width: 24)
                Text(label)
                    .font(.polaBody(15))
                    .foregroundStyle(tint)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color(white: 0.3))
            }
            .padding(16)
            .background(Color(white: 0.08))
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
}

#Preview {
    SettingsView()
        .environment(AuthViewModel())
}
