import Foundation
import AuthenticationServices
import GoogleSignIn

enum AuthProvider {
    case apple, google
}

struct AuthTokens {
    let accessToken: String
    let provider: AuthProvider
}

@MainActor
final class AuthService {
    static let shared = AuthService()
    private init() {}

    func signInWithApple(credential: ASAuthorizationAppleIDCredential) async throws -> AuthTokens {
        guard let identityTokenData = credential.identityToken,
              let identityToken = String(data: identityTokenData, encoding: .utf8) else {
            throw AuthError.invalidCredential
        }
        let token = try await APIService.shared.authenticateApple(identityToken: identityToken)
        return AuthTokens(accessToken: token, provider: .apple)
    }

    func signInWithGoogle() async throws -> AuthTokens {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else {
            throw AuthError.noRootViewController
        }

        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootVC)
        guard let idToken = result.user.idToken?.tokenString else {
            throw AuthError.invalidCredential
        }

        let token = try await APIService.shared.authenticateGoogle(idToken: idToken)
        return AuthTokens(accessToken: token, provider: .google)
    }

    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        KeychainService.deleteToken()
    }
}

enum AuthError: LocalizedError {
    case invalidCredential
    case noRootViewController
    case serverError(String)

    var errorDescription: String? {
        switch self {
        case .invalidCredential: "Identifiant invalide."
        case .noRootViewController: "Erreur d'interface."
        case .serverError(let msg): msg
        }
    }
}
