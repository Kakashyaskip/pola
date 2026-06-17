import Foundation

@MainActor
final class APIService {
    static let shared = APIService()
    private init() {}

    private let baseURL = "https://pola-api.PLACEHOLDER.workers.dev"

    private func request<T: Decodable>(
        path: String,
        method: String = "GET",
        body: (any Encodable)? = nil,
        authenticated: Bool = true
    ) async throws -> T {
        guard let url = URL(string: baseURL + path) else {
            throw APIError.invalidURL
        }
        var req = URLRequest(url: url)
        req.httpMethod = method
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if authenticated, let token = KeychainService.getToken() {
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        if let body {
            req.httpBody = try JSONEncoder().encode(body)
        }

        let (data, response) = try await URLSession.shared.data(for: req)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw APIError.httpError(httpResponse.statusCode)
        }

        return try JSONDecoder().decode(T.self, from: data)
    }

    func authenticateApple(identityToken: String) async throws -> String {
        struct Body: Encodable { let identityToken: String }
        struct Response: Decodable { let token: String }
        let res: Response = try await request(
            path: "/auth/apple",
            method: "POST",
            body: Body(identityToken: identityToken),
            authenticated: false
        )
        return res.token
    }

    func authenticateGoogle(idToken: String) async throws -> String {
        struct Body: Encodable { let idToken: String }
        struct Response: Decodable { let token: String }
        let res: Response = try await request(
            path: "/auth/google",
            method: "POST",
            body: Body(idToken: idToken),
            authenticated: false
        )
        return res.token
    }
}

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(Int)

    var errorDescription: String? {
        switch self {
        case .invalidURL: "URL invalide."
        case .invalidResponse: "Réponse invalide."
        case .httpError(let code): "Erreur serveur (\(code))."
        }
    }
}
