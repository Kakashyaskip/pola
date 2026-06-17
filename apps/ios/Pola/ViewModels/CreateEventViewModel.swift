import Foundation
import SwiftUI

@Observable
@MainActor
final class CreateEventViewModel {
    var step: Int = 1
    var totalSteps: Int = 6
    var isLoading = false
    var errorMessage: String?

    // Step 1 — nom
    var name: String = ""
    var nameSuggestions = ["Soirée d'anniversaire", "Mariage", "Voyage entre amis", "Notre fête", "Soirée"]

    // Step 2 — date de fin
    var endDate: Date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()

    // Step 3 — révélation
    var revealMode: PolaEvent.RevealMode = .after

    // Step 4 — filtre
    var selectedFilter: PolaEvent.FilmFilter = .original

    // Step 5 — couverture (image à implémenter Sprint 2)
    var coverImageData: Data? = nil

    // Step 6 — invités
    var maxGuests: Int = 10
    var shotsPerPerson: Int = 24
    var isPublic: Bool = true

    let guestOptions = [5, 10, 15, 20, 30, 50]
    let shotOptions = [5, 10, 16, 24, 36]

    var canProceed: Bool {
        switch step {
        case 1: !name.trimmingCharacters(in: .whitespaces).isEmpty
        default: true
        }
    }

    func next() {
        guard step < totalSteps else { return }
        step += 1
    }

    func previous() {
        guard step > 1 else { return }
        step -= 1
    }

    func create() async -> Bool {
        isLoading = true
        // TODO: Sprint 1 API — POST /events
        try? await Task.sleep(for: .milliseconds(500))
        isLoading = false
        return true
    }
}
