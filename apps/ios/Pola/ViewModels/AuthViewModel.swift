import Foundation
import AuthenticationServices

@Observable
@MainActor
final class AuthViewModel: NSObject {
    var isAuthenticated = false
    var isLoading = false
    var errorMessage: String?

    override init() {
        super.init()
        isAuthenticated = KeychainService.getToken() != nil
    }

    func signInWithApple() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }

    func signInWithGoogle() {
        isLoading = true
        errorMessage = nil
        Task {
            do {
                let tokens = try await AuthService.shared.signInWithGoogle()
                KeychainService.saveToken(tokens.accessToken)
                isAuthenticated = true
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }

    func signOut() {
        AuthService.shared.signOut()
        isAuthenticated = false
    }
}

extension AuthViewModel: ASAuthorizationControllerDelegate {
    nonisolated func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        Task { @MainActor in
            isLoading = true
            do {
                let tokens = try await AuthService.shared.signInWithApple(credential: credential)
                KeychainService.saveToken(tokens.accessToken)
                isAuthenticated = true
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }

    nonisolated func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: any Error
    ) {
        Task { @MainActor in
            if (error as? ASAuthorizationError)?.code != .canceled {
                errorMessage = error.localizedDescription
            }
        }
    }
}
