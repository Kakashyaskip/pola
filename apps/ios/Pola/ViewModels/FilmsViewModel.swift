import Foundation

@Observable
@MainActor
final class FilmsViewModel {
    var activeEvents: [PolaEvent] = []
    var pastAlbums: [PolaEvent] = []
    var isLoading = false
    var errorMessage: String?

    func load() async {
        isLoading = true
        // TODO: Sprint 1 API — fetch events from API
        // Pour l'instant, données de démo
        try? await Task.sleep(for: .milliseconds(300))
        activeEvents = []
        pastAlbums = []
        isLoading = false
    }
}
