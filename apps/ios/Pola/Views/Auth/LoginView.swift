import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @Environment(AuthViewModel.self) private var auth

    var body: some View {
        ZStack {
            Color.polaBlack.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Wordmark
                Text("pola")
                    .font(.polaWordmark(72))
                    .foregroundStyle(.white)
                    .kerning(-3)

                Spacer().frame(height: 16)

                Text("Capturez l'instant.\nRévélé le lendemain.")
                    .font(.polaBody(17))
                    .foregroundStyle(Color(white: 0.55))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)

                Spacer()

                // Boutons auth
                VStack(spacing: 12) {
                    PolaButton(
                        "Continuer avec Apple",
                        icon: "apple.logo",
                        style: .primary,
                        isLoading: auth.isLoading
                    ) {
                        auth.signInWithApple()
                    }

                    GoogleSignInButton(isLoading: auth.isLoading) {
                        auth.signInWithGoogle()
                    }

                    PolaButton(
                        "Invité ? Scanner le QR",
                        icon: "qrcode.viewfinder",
                        style: .ghost
                    ) {
                        // TODO: Sprint 2 — guest join flow
                    }
                }
                .padding(.horizontal, 24)

                Spacer().frame(height: 24)

                // Footer légal
                Group {
                    Text("En continuant, vous acceptez nos ")
                    + Text("CGU").underline()
                    + Text(" et notre ")
                    + Text("politique de confidentialité").underline()
                }
                .font(.polaCaption(12))
                .foregroundStyle(Color(white: 0.35))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

                Spacer().frame(height: 40)
            }
        }
        .alert("Erreur", isPresented: Binding(
            get: { auth.errorMessage != nil },
            set: { if !$0 { auth.errorMessage = nil } }
        )) {
            Button("OK") { auth.errorMessage = nil }
        } message: {
            Text(auth.errorMessage ?? "")
        }
    }
}

private struct GoogleSignInButton: View {
    let isLoading: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                if isLoading {
                    ProgressView().tint(.polaBlack).scaleEffect(0.85)
                } else {
                    GoogleLogoShape()
                        .frame(width: 18, height: 18)
                    Text("Continuer avec Google")
                        .font(.polaMedium(15))
                        .foregroundStyle(.polaBlack)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .disabled(isLoading)
    }
}

private struct GoogleLogoShape: View {
    var body: some View {
        // G stylisé simplifié — remplacer par asset SVG officiel si disponible
        ZStack {
            Circle().fill(Color.clear)
            Text("G")
                .font(.system(size: 15, weight: .bold, design: .default))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue, .red, .yellow, .green],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        }
    }
}

#Preview {
    LoginView()
        .environment(AuthViewModel())
}
