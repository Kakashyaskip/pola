import Foundation

struct PolaEvent: Identifiable, Codable {
    let id: String
    var name: String
    var endDate: Date
    var revealMode: RevealMode
    var filter: FilmFilter
    var coverImageURL: String?
    var maxGuests: Int
    var shotsPerPerson: Int
    var isPublic: Bool
    var status: EventStatus
    var photosCount: Int
    var guestsCount: Int
    var createdAt: Date

    enum RevealMode: String, Codable, CaseIterable {
        case during = "during"
        case after = "after"
        case delay = "delay"

        var label: String {
            switch self {
            case .during: "Pendant l'événement"
            case .after: "Après l'événement"
            case .delay: "Délai supplémentaire"
            }
        }
    }

    enum FilmFilter: String, Codable, CaseIterable {
        case original = "original"
        case grain = "grain"
        case fade = "fade"

        var label: String {
            switch self {
            case .original: "Original"
            case .grain: "Grain"
            case .fade: "Fade"
            }
        }

        var description: String {
            switch self {
            case .original: "Couleurs vraies, tons nets."
            case .grain: "Grain argentique prononcé."
            case .fade: "Tons délavés, nostalgique."
            }
        }
    }

    enum EventStatus: String, Codable {
        case active, revealed, expired
    }
}
