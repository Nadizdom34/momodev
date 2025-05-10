import SwiftUI

/// Represents a user's gym status to show in the UI and assigns a color to each status
enum GymStatus: String, CaseIterable {
    case inGym = "At Gym"
    case notInGym = "No Gym"
    case goingToGym = "Going to Gym"
    var color: Color {
        switch self {
        case .inGym: return .green
        case .notInGym: return .red
        case .goingToGym: return .orange
        }
    }
}

